pragma solidity ^0.8.7;

contract MyContract{
    string public str;

    function setStr(string memory _str) public {
      str = _str;
    }
}