pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address payable[] public players;
    address payable manager;

    constructor(){
        manager = msg.sender;
       // adding the manager to the lottery
        players.push(payable(manager));
    }

    receive() external payable{
        // the manager can not participate in the lottery
        require(msg.sender != manager);
        
        require(msg.value >= 0.01 ether);
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }

    function pickWinner() public{
       require(msg.sender == manager);
       require(players.length >=3);

       uint r = random();
       address payable winner;

       uint index = r% players.length;
       winner = players[index];

       winner.transfer(address(this).balance);

       players = new address payable[](0);
    }
} 