pragma solidity >=0.5.0 <0.9.0;

contract FixedArrays{
    uint[3] public nos = [12,34,55];

    bytes1 public b1;
    bytes1 public b2;
    bytes1 public b3;
    
    function setEle(uint index,uint value) public{
       nos[index] = value;
    }

    function getLength() public view returns(uint){
        return nos.length;
    }

    function setBytesArray() public {
      b1 = 'a'; // => 0x61 (ASCII code of `a` in hex)
     b2 = "b"; // => 0x6162
     b3 = 'z'; // => 0x7A  
    }
}