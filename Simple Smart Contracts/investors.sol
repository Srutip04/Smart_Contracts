//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract InvestorsWallets{
    uint fortune;
    address payable[] investorWallets;
    mapping(address => uint) investors;

    constructor() payable{
        fortune = msg.value;
    }

    function payInvestors(address payable wallet ,uint amt) public{
        investorWallets.push(wallet);
        investors[wallet] = amt;
    }

    function payout() private {
        for(uint i=0; i<investorWallets.length;i++){
            investorWallets[i].transfer(investors[investorWallets[i]]);
        }
    }

    function makePayment() public{
        payout();
    }

    function checkInvestors() public view returns (uint) {
       return investorWallets.length;
    } 
}