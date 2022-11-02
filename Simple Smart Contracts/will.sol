//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Will{
    address public owner;
    uint fortune;
    bool deceased;

    constructor() payable {
        owner = msg.sender;
        fortune = msg.value; //how much ether is sent
        deceased = false;
    }

    modifier onlyOwner(){
        require( msg.sender == owner);
        _;
    }

    modifier mustBeDeceased(){
        require(deceased == true);
        _;
    }
    //list of family wallets
    address payable[] familyWallets;
    
    //map through inheritance
    mapping(address => uint) inheritance;

    //set inheritance for each address

    function setInheritance(address payable wallet ,uint amt) public{
        familyWallets.push(wallet);
        inheritance[wallet] = amt;
    }




}