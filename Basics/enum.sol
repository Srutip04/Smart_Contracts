pragma solidity ^0.8.7;

contract usevar{
    enum actionChoices{left,right,down,up}
    actionChoices public choice;

    function stChange1() public{
        choice = actionChoices.left;
    }

     function stChange2() public{
        choice = actionChoices.up;
    }
     function stChange3() public{
        choice = actionChoices.down;
    }
}