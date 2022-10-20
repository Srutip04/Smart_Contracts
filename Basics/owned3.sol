pragma solidity ^0.8.7;
contract owned{
   address public owner;
    constructor()public{
        owner = msg.sender;
    }

    modifier onlyOwner(){
      require(owner == msg.sender,'u are not owner');
      _;
    }
}
