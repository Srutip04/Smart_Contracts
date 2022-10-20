pragma solidity ^0.8.7;

contract MyContract{

    uint public balRevc;
    function receiveMoney() public payable{
    balRevc = msg.value;
}

function getBal() public view returns(uint) {
    return address(this).balance;
}


function withDraw() public {
    address  payable to = payable(msg.sender);
    to.transfer(this.getBal());
}

function transferto(address payable _to) public {
    _to.transfer(this.getBal());
}
}