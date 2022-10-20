pragma solidity ^0.8.7;

contract MyContract {
    address owner;
    bool public  paused;

    constructor() public{
        owner = msg.sender;
    }

    function sendMoney() public payable{

    }

    function setPaused(bool _paused) public {
         require(msg.sender == owner, "You're not the owner");
         require(paused,"Contract is paused");
         paused = _paused;
    }

    function withdrawAllMoney(address payable _to) public {
        require(msg.sender == owner, "You're not the owner");
        _to.transfer(address(this).balance);
    }

    function destroySmartContract(address payable _to) public {
        require(msg.sender == owner,"You're not the owner");
        selfdestruct(_to);
    }
}