pragma solidity >=0.5.0 <0.9.0;

//cannot be deployed
abstract contract BaseContract{
    int public x;
    address public owner;

    constructor(){
        x= 5;
        owner = msg.sender;
    }

    function setX(int _x) public virtual;
}

contract A is BaseContract{
    //cannt override state variables of base contract
    int public y = 3;

    function setX(int _x) public override{
        x = _x;
    }
}