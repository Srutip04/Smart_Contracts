pragma solidity ^0.8.7;

contract variables{
    address public myadd;

    constructor() public{
        myadd = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    }

    function getbal() public view returns(uint256){
        return myadd.balance;
    }
}