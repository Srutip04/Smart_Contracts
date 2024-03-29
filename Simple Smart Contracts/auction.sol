// SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract AuctionCreator{
    Auction[] public auctions;

    function createAuction() public{
        Auction newAuction = new Auction(msg.sender);
        auctions.push(newAuction);
    }
}

contract Auction{
    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;

    enum State {started,running,ended,canceled}
    State public auctionState;

    uint public highestBindingBid;
    address payable public highestBidder;

    mapping(address => uint ) public bids;
    uint bidIncrement;

    constructor(address eoa){
        owner = payable(eoa);
        auctionState = State.running;
        startBlock = block.number;
        endBlock = startBlock + 3;
        ipfsHash = "";
        bidIncrement = 1000000000000000000;
    }

    modifier notOwner(){
        require(msg.sender != owner);
        _;
    }

    modifier afterStart(){
        require(block.number >= startBlock);
        _;
    }

    modifier beforeEnd(){
        require(block.number <= endBlock);
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    function min(uint a, uint b) pure internal returns(uint){
        if(a<=b){
            return a;
        }else{
            return b;
        }
    }

    function cancelAuction() public onlyOwner{
        auctionState = State.canceled;
    }


    function placeBid() public payable notOwner afterStart beforeEnd{
        require(auctionState == State.running);
        require(msg.value >= 100);

        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid > highestBindingBid);

        bids[msg.sender] = currentBid;

        if(currentBid <= bids[highestBidder]){
            highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
        }else{
            highestBindingBid = min(currentBid,bids[highestBidder] + bidIncrement);
            highestBidder = payable(msg.sender);
        }

    }

    function finalizeAuction() public {
        require(auctionState == State.canceled || block.number > endBlock);
        require(msg.sender == owner || bids[msg.sender] > 0);

        address payable receipient;
        uint value;

        if(auctionState == State.canceled){ //auction was canceled
            receipient = payable(msg.sender);
            value = bids[msg.sender];
        }else{ //auction ended (not canceled)
           if(msg.sender == owner){
             receipient = owner;
             value = highestBindingBid;
           }else{ //this is a bidder
               if(msg.sender == highestBidder){
                 receipient = highestBidder;
                 value = bids[highestBidder] - highestBindingBid;
               }else{ // this is neither the owner nor the highestBidder
                  receipient = payable(msg.sender);
                  value = bids[msg.sender];
               }
           }
        }
        bids[receipient] = 0;
        receipient.transfer(value);
    }

}