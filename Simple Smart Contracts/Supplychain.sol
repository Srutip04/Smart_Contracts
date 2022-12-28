pragma solidity ^0.6.0;

contract Ownable{
    address payable _owner;

    constructor() public{
        _owner = msg.sender;
    }

    modifier onlyOwner(){
        require(isOwner(), "Youre not the owner");
        _;
    }

    function isOwner() public view returns(bool){
        return(msg.sender == _owner);
    }
}

contract Item{
    uint public priceInWei;
    uint public pricePaid;
    uint public index;

    ItemManager parentContract;

    constructor(ItemManager _parentContract,uint _priceInWei,uint _index) public {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable{
      require(pricePaid == 0,"Item is paid already");
      require(priceInWei == msg.value,"only full payments allowed");
      pricePaid += msg.value;
      (bool success,) = address(parentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayment(uint256)",index));
      require(success,"The transaction wasnt successful,cancelling");
    }
    fallback() external{}
}

contract ItemManager is Ownable {
    enum SupplyChainState{Created, Paid, Delivered}

    struct S_Item{
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }

    mapping(uint => S_Item) public items;
    uint itemIndex;

    event SupplyChainStep(uint _itemIndex,uint _step,address _itemAddress);

    function createItem(string memory _identifier,uint _itemPrice) public onlyOwner{
        Item item = new Item(this, _itemPrice,itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex,uint(items[itemIndex]._state), address(item));
        itemIndex++;
    }

    function triggerPayment(uint _itemIndex) public payable{
      require(items[_itemIndex]._itemPrice == msg.value,"only full payments accepted");
      require(items[_itemIndex]._state == SupplyChainState.Created,"Item is further in the chain");
      items[_itemIndex]._state = SupplyChainState.Paid;
      emit SupplyChainStep(_itemIndex,uint(items[_itemIndex]._state),address(items[_itemIndex]._item));
    }

    function triggerDelivery(uint _itemIndex) public onlyOwner{
      require(items[_itemIndex]._state == SupplyChainState.Paid,"Item should be paid");
      items[_itemIndex]._state = SupplyChainState.Delivered;
      emit SupplyChainStep(_itemIndex,uint(items[_itemIndex]._state),address(items[_itemIndex]._item));

    }
}
