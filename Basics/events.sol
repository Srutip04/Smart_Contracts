//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Events{
    event NewTrade(
        uint indexed date,
        address from,
        address indexed to,
        uint indexed amt
    );

    function trade(address to,uint amt) external {
        emit NewTrade(block.timestamp, to, amt);
    }
}