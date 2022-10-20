pragma solidity ^0.8.7;

//max range 0- 2^256
contract variables{
    uint8 public myint =2;
    bool public mybool;
    string public mystr;

    function changeStr()public{
        mystr="Hello";
    }

    function changeVal()public{
        mybool = true;
    }

    function increment() public {
        myint++;
    }
     function decrement() public {
        myint--;
    }
    function setStr(string memory to) public returns(string memory){
        mystr= to;
        return(mystr);
    }
}