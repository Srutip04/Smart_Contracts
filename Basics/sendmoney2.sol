pragma solidity ^0.8.7;

contract MyContract{
    mapping(address => uint) public balrevc;
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function sendMoney() public payable {
      balrevc[msg.sender] += msg.value;
    }

    function withDrawMoney(address payable _to, uint _amt) public{
        require(balrevc[msg.sender] >= _amt,"Not enough funds");
        balrevc[msg.sender] -= _amt ;
        _to.transfer(_amt);
    }

    function withdrawAllMoney(address payable _to) public{
        uint balanceToSend = balrevc[msg.sender];
        balrevc[msg.sender] = 0;
        _to.transfer(balanceToSend);
    }
}