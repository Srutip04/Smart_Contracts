pragma solidity ^0.8.7;

contract usevar{
    struct customer{
        address add;
        uint amt;
    }
    customer public fund;

    function change()public{
        fund.add = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        fund.amt = 25;
    }
}