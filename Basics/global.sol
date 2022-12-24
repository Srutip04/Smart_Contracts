pragma solidity >=0.5.0 <0.9.0;

contract GlobalVariables{

    // the current block number
uint public block_number = block.number;
 
// the block difficulty
uint public difficulty = block.difficulty;
 
// the block gas limit
uint public gaslimit = block.gaslimit;
 
    address public owner;
    uint public sentVal;
    constructor(){
        owner=msg.sender;
    }

    function changeOwner() public{
        owner = msg.sender;
    }

    function sendEther() public payable{
        sentVal = msg.value;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    } 

    //how much gas

    function howMuchGas() public view returns(uint){
        uint start = gasleft();
        uint j=1;
        for(uint i=1;i<20;i++){
            j*=i;
        }

        uint end = gasleft();
        return start - end;
    }

}
