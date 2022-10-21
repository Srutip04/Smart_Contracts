pragma solidity >=0.5.0 <0.9.0;

contract BytesAndStrings{
    bytes public b1 = "abc";
    string public s1 = "abc";

    function addEle() public{
        b1.push('x');
    }

    function getEle(uint i) public view returns(bytes1){
        return b1[i];
    }

    function getLength() public view returns(uint){
        return b1.length;
    }
}