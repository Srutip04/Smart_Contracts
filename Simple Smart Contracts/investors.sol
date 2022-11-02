//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract InvestorsWallets{
    address payable[] investorWallets;
    mapping(address => uint) investors;

    function payInvestors(address payable wallet ,uint amt) public{
        investorWallets.push(wallet);
        investors[wallet] = amt;
    }

    function checkInvestors() public view returns (uint) {
       return investorWallets.length;
    } 
}