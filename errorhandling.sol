pragma solidity ^0.8.7;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";
// import "./owned3.sol";

contract errorHandling is  Ownable{
    uint public balance;
   

    function getmoney()public payable onlyOwner{
        // if(owner != msg.sender){
        //     revert('Not owner');
        // }
        balance += msg.value;
    }

    function withdraw( uint amt) public onlyOwner{
       
        assert(balance >= amt);
        balance-= amt;
      
    }
}