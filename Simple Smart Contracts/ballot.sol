pragma solidity >= 0.7.0 < 0.9.0;

contract Ballot{

    //struct is a method to create your own data type

    //voters: voted = bool ,access to vote = uint, vote index = uint

    struct Voter{
        uint vote;
        bool voted;
        uint weight;


    }

    struct Proposal{
        //bytes are a basic uint measurement of info in computer processing
        bytes32 name; // the name of each proposal
        uint voteCount; // no of accumulated votes
    }

    Proposal[] public proposals;

    //mapping allows us to create a store value with keys and indexes
    mapping(address => Voter) public voters; //voters get address as a key and voter for value
    
    address public chairperson;

}

