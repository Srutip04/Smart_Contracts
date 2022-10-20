pragma solidity ^0.8.7;

contract wallet {
    address public owner;
    bool public pause;
    constructor() public {
        owner = msg.sender; //the one who deployed the contract
    }

    struct Payment {
        uint amt;
        uint timestamp;
    }

    struct Balance{
        uint totbal;
        uint numpay; //no of transactions
        mapping(uint => Payment) payments;
    }
    mapping(address => Balance)public bal_rec;
    event sentmoney(address indexed add1,uint amt1);
    event recmoney(address indexed add2,uint amt2);
   
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    modifier whilenotpaused(){
        require(pause == false,'sc is paused');
        _;
    }
    function change(bool ch) public onlyOwner{
        pause = ch;
    }

    function sendmoney()public payable whilenotpaused{
        bal_rec[msg.sender].totbal += msg.value;
        bal_rec[msg.sender].numpay += 1;
        Payment memory pay = Payment(msg.value,block.timestamp);
        bal_rec[msg.sender].payments[bal_rec[msg.sender].numpay] = pay;
        emit sentmoney(msg.sender,msg.value);
    }
    function getbal() public view whilenotpaused returns(uint){
        return bal_rec[msg.sender].totbal;
    }
    function convert(uint amtinwei) public pure returns(uint){
        return amtinwei/1 ether;
    }
    function withdraw(uint _amt)public whilenotpaused{
        require(bal_rec[msg.sender].totbal >= _amt,'not enough funds');
        bal_rec[msg.sender].totbal -= _amt;
        payable(msg.sender).transfer(_amt);
        emit recmoney(msg.sender,_amt);
    }
    function destroy(address payable ender) public onlyOwner{
        selfdestruct(ender);
    }
}