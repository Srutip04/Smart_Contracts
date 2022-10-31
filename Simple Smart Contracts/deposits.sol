//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Deposit{

   address public immutable admin;

   constructor(){
       admin = msg.sender;
   }

    receive() external payable{}

    function getBalance() public view returns(uint){
        return address(this).balance;
    }    

    function transferBal(address payable receipient) public{
        require(admin == msg.sender);
        uint bal = getBalance();
        receipient.transfer(bal);
    }
}