pragma solidity ^0.8.7;


contract MyContract{
    address public myAdd;

    function setAdd(address _myAdd) public {
        myAdd = _myAdd;
    }

    function getBal() public view returns(uint){
        return myAdd.balance;
    }
}