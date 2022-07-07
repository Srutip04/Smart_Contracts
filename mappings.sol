pragma solidity ^0.8.7;

contract usevar{
    mapping(uint => address) public mymap;

    function init()public{
        mymap[0] = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    }
    function inituser(uint k ,address add) public {
        mymap[k] = add;
    }
}