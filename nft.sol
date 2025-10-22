// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFT is ERC721, Ownable {
    using Strings for uint256;

    // Constants
    uint256 public constant MAX_TOKENS = 10000;
    uint256 private constant TOKENS_RESERVED = 5;
    uint256 public constant MAX_MINT_PER_TX = 10;

    // State variables
    uint256 public price = 0.1 ether;
    bool public isSaleActive;
    uint256 public totalSupply;
    mapping(address => uint256) private mintedPerWallet;

    string public baseUri;
    string public baseExtension = ".json";

    constructor() ERC721("NFT Name", "SYMBOL") Ownable(msg.sender) {
        baseUri = "ipfs://xxxxxxxxxxxxxxxxxxxxxxxxxxxxx/";
        
        // Mint reserved tokens to the owner
        for (uint256 i = 1; i <= TOKENS_RESERVED; ++i) {
            _safeMint(msg.sender, i);
        }
        totalSupply = TOKENS_RESERVED;
    }

    // ------------------------------
    // Public Minting
    // ------------------------------
    function mint(uint256 _numTokens) external payable {
        require(isSaleActive, "The sale is paused.");
        require(_numTokens > 0 && _numTokens <= MAX_MINT_PER_TX, "Invalid mint amount.");
        require(mintedPerWallet[msg.sender] + _numTokens <= MAX_MINT_PER_TX, "Max per wallet exceeded.");
        require(totalSupply + _numTokens <= MAX_TOKENS, "Exceeds total supply.");
        require(msg.value >= _numTokens * price, "Insufficient ETH.");

        for (uint256 i = 1; i <= _numTokens; ++i) {
            uint256 tokenId = totalSupply + i;
            _safeMint(msg.sender, tokenId);
        }

        mintedPerWallet[msg.sender] += _numTokens;
        totalSupply += _numTokens;
    }

    // ------------------------------
    // Owner Controls
    // ------------------------------
    function flipSaleState() external onlyOwner {
        isSaleActive = !isSaleActive;
    }

    function setBaseUri(string memory _baseUri) external onlyOwner {
        baseUri = _baseUri;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function withdrawAll() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance.");

        uint256 balanceOne = (balance * 70) / 100;
        uint256 balanceTwo = (balance * 30) / 100;

        (bool successOne, ) = payable(0x7ceB3cAf7cA83D837F9d04c59f41a92c1dC71C7d).call{value: balanceOne}("");
        (bool successTwo, ) = payable(0x7ceB3cAf7cA83D837F9d04c59f41a92c1dC71C7d).call{value: balanceTwo}("");
        require(successOne && successTwo, "Transfer failed.");
    }

    // ------------------------------
    // Metadata
    // ------------------------------
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
            : "";
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseUri;
    }
}
