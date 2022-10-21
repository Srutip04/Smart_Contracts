pragma solidity >=0.5.0 <0.9.0;

contract Property{
    // declaring state variables saved in contract's storage
    int public price;// by default is private
    string public loc ;
    address immutable public owner;

    bool public sold;
    uint8 public x= 255;
    int8 public y =-10;

     // declaring a constant
    int constant area = 100;



    constructor(int _price,string memory _loc){
        price = _price;
        loc = _loc;
        owner = msg.sender; //address of the acc that deploys the contract
    }
    
    //interger overflow
    function f1() public{
        unchecked {x+=1;}
    }

    function setPrice(int _price) public {
        int a; // local variable saved on stack
        a = 10;
        price = _price;
    }

     
    // getter function, returns a state variable
    // a function declared `view` does not alter the blockchain 
    function getPrice() public view returns(int){
        return price;
    }

    function setLocation(string memory _loc) public{
        loc = _loc;
    }

}