// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyERC1155 is ERC1155, ERC1155Supply, Ownable {
    using Strings for uint256;

    // Sale controls
    bool public isSaleActive;

    // Per-token pricing (in wei)
    mapping(uint256 => uint256) public pricePerToken;

    // Per-token max supply (0 = unlimited)
    mapping(uint256 => uint256) public maxSupply;

    // Optional per-wallet per-token mint limit (0 = unlimited)
    mapping(uint256 => uint256) public maxPerWallet;

    // Track how many of each token each wallet minted (if using maxPerWallet)
    mapping(address => mapping(uint256 => uint256)) public mintedPerWallet;

    // Metadata base URI - ERC1155 URI should contain "{id}" which client replaces with hex id (or you can return full URI)
    // Example: "ipfs://.../{id}.json"
    string public name;
    string public symbol;

    event TokenPriceSet(uint256 indexed id, uint256 price);
    event MaxSupplySet(uint256 indexed id, uint256 maxSupply);
    event MaxPerWalletSet(uint256 indexed id, uint256 maxPerWallet);

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _uri // e.g. "ipfs://Qm.../{id}.json"
    ) ERC1155(_uri) {
        name = _name;
        symbol = _symbol;
        isSaleActive = false;
    }

    // -------------------------
    // Owner functions
    // -------------------------

    /// @notice Toggle public sale on/off
    function flipSaleState() external onlyOwner {
        isSaleActive = !isSaleActive;
    }

    /// @notice Set the base URI (must include "{id}" if using id substitution client-side)
    function setURI(string memory newuri) external onlyOwner {
        _setURI(newuri);
    }

    /// @notice Set price for a token id (in wei)
    function setPrice(uint256 id, uint256 price) external onlyOwner {
        pricePerToken[id] = price;
        emit TokenPriceSet(id, price);
    }

    /// @notice Set max supply for a token id (0 = unlimited)
    function setMaxSupply(uint256 id, uint256 _maxSupply) external onlyOwner {
        maxSupply[id] = _maxSupply;
        emit MaxSupplySet(id, _maxSupply);
    }

    /// @notice Set per-wallet limit for a token id (0 = unlimited)
    function setMaxPerWallet(uint256 id, uint256 _maxPerWallet) external onlyOwner {
        maxPerWallet[id] = _maxPerWallet;
        emit MaxPerWalletSet(id, _maxPerWallet);
    }

    /// @notice Owner mint (no payment) to any address
    function ownerMint(address to, uint256 id, uint256 amount, bytes calldata data) external onlyOwner {
        _mintWithSupplyChecks(to, id, amount, data);
    }

    /// @notice Owner batch mint
    function ownerMintBatch(address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external onlyOwner {
        require(ids.length == amounts.length, "Length mismatch");
        // check max supplies
        for (uint256 i = 0; i < ids.length; ++i) {
            if (maxSupply[ids[i]] != 0) {
                require(totalSupply(ids[i]) + amounts[i] <= maxSupply[ids[i]], "Exceeds max supply");
            }
        }
        _mintBatch(to, ids, amounts, data);
    }

    /// @notice Withdraw contract balance to owner
    function withdrawAll(address payable to) external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance");
        (bool sent, ) = to.call{value: balance}("");
        require(sent, "Withdraw failed");
    }

    // -------------------------
    // Public minting
    // -------------------------

    /// @notice Public mint function for a single token id
    /// @param id Token type id
    /// @param amount Number to mint
    function mint(uint256 id, uint256 amount, bytes calldata data) external payable {
        require(isSaleActive, "Sale is not active");
        require(amount > 0, "Amount is 0");

        // price
        uint256 price = pricePerToken[id];
        if (price > 0) {
            require(msg.value >= price * amount, "Insufficient ETH");
        }

        // per-wallet limit
        if (maxPerWallet[id] != 0) {
            require(mintedPerWallet[msg.sender][id] + amount <= maxPerWallet[id], "Per-wallet limit exceeded");
            mintedPerWallet[msg.sender][id] += amount;
        }

        _mintWithSupplyChecks(msg.sender, id, amount, data);
    }

    /// @notice Public batch mint (multiple ids)
    function mintBatch(uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external payable {
        require(isSaleActive, "Sale is not active");
        require(ids.length == amounts.length, "Length mismatch");
        uint256 totalCost = 0;

        // compute cost and check per-wallet limits and max supply
        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 amt = amounts[i];
            require(amt > 0, "Amount 0 in batch");

            uint256 price = pricePerToken[id];
            if (price > 0) {
                totalCost += price * amt;
            }

            if (maxPerWallet[id] != 0) {
                require(mintedPerWallet[msg.sender][id] + amt <= maxPerWallet[id], "Per-wallet limit exceeded");
                mintedPerWallet[msg.sender][id] += amt;
            }

            if (maxSupply[id] != 0) {
                require(totalSupply(id) + amt <= maxSupply[id], "Exceeds max supply");
            }
        }

        if (totalCost > 0) {
            require(msg.value >= totalCost, "Insufficient ETH for batch");
        }

        _mintBatch(msg.sender, ids, amounts, data);
    }

    // -------------------------
    // Internal helpers
    // -------------------------

    function _mintWithSupplyChecks(address to, uint256 id, uint256 amount, bytes memory data) internal {
        if (maxSupply[id] != 0) {
            require(totalSupply(id) + amount <= maxSupply[id], "Exceeds max supply");
        }
        _mint(to, id, amount, data);
    }

    // -------------------------
    // Overrides required by Solidity
    // -------------------------
    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    // Optional: convenience view to return token URI with decimal id appended (if you prefer)
    // Note: ERC1155 clients usually perform "{id}" substitution with hex id of 32 bytes.
    function uriAsString(uint256 id) external view returns (string memory) {
        string memory base = uri(id); // base may contain {id}
        return base;
    }

    // Fallback to accept native token payments
    receive() external payable {}
    fallback() external payable {}
}
