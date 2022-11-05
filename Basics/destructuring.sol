//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract DestructuringFunc{
    uint public changeVal;
    string public tom = "Baby";

    function f() public view returns (uint,bool, string memory){
        return (3,true,'GoodBye!');
    }

    function g() public {
        (changeVal,,tom) = f();
    }
}