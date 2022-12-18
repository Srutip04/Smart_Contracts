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
    
    constructor(bytes32[] memory proposalNames){
     
     chairperson = msg.sender;
     
     //add 1 to chairperson
     voters[chairperson].weight = 1;

     //will add the proposal names to the smart contract upon deployment
      for(uint i=0;i<proposalNames.length;i++){
         proposals.push(Proposal({
             name: proposalNames[i],
             voteCount: 0
         }));
      }
    }

    //Function to authenticate voters

    function giveRightToVote(address voter) public{
        require(msg.sender == chairperson,"Only the chairperson can give access to vote");
        require(!voters[voter].voted,"The voter has already voted");
        require(voters[voter].weight == 0);

        voters[voter].weight == 1; //ability to vote
    }

    //function for voting 

    function vote(uint proposal) public{
        Voter storage sender = voters[msg.sender];
        require(sender.weight !=0,"Has no right to vote");
        require(!sender.voted,"Already voted");
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount = proposals[proposal].voteCount + sender.weight;

    }

    //function for voting results

    // function that shows the winning proposal by integer

    function winningProposal() public view returns(uint winningProposal_){
        uint winningVoteCount = 0;
        for(uint i=0;i<proposals.length;i++){
            if(proposals[i].voteCount > winningVoteCount){
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
    }

    //function that shows the winner by name

    function winningName() public view returns(bytes32 winningName_) {

        winningName_ = proposals[winningProposal()].name;

    }

}
