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
        // require(msg.sender != manager);
        
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
        //anyone can pick the winner and finish the lottery, if there are at least 10 players.
    //    require(msg.sender == manager);
       require(players.length >=10);

       uint r = random();
       address payable winner;
        // computing a random index of the array
       uint index = r% players.length;
       winner = players[index];

       uint managerFee = (address(this).balance * 10) / 100; //fee 10%
       uint winnerFee = (address(this).balance * 90) /100; //90%

        // transferring 90% of contract's balance to the winner
       winner.transfer(winnerFee);
        // transferring 10% of contract's balance to the manager
       payable(manager).transfer(managerFee);
        // resetting the lottery for the next round
       players = new address payable[](0);
    }
} 