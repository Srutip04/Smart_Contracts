// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.5;

contract CrowdFunding{
    mapping(address => uint) public contributors;
    address public admin;
    uint public noOfContributors;
    uint public minContribution;
    uint public deadline; //timestamp
    uint public goal;
    uint public raisedAmt;
    struct Request{
        string desc;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voters;
    }
    
    // mapping of spending requests
    // the key is the spending request number (index) - starts from zero
    // the value is a Request struct
    mapping(uint => Request) public requests;

    uint public numRequests;

    constructor(uint _goal,uint _deadline){
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minContribution = 100 wei;
        admin = msg.sender;
    }
    
     // events to emit
    event ContributeEvent(address _sender,uint _value);
    event CreateRequestEvent(string _desc,address _recipient,uint _value);
    event MakePaymentEvent(address _recipient,uint _value);


    function contribute() public payable{
        require(block.timestamp < deadline,"Deadline has passed");
        require(msg.value >= minContribution,"Min contribution not met");

        if(contributors[msg.sender] == 0){
          noOfContributors++;
        }

        contributors[msg.sender] += msg.value;
        raisedAmt += msg.value;

        emit ContributeEvent(msg.sender,msg.value);
    }

    receive() payable external{
        contribute();
    }

    function getbal() public view returns(uint){
        return  address(this).balance;
    }
    
    // a contributor can get a refund if goal was not reached within the deadline
    function getRefund() public{
        //deadline has passed and the goal has not reached
        require(block.timestamp > deadline && raisedAmt < goal);
        require(contributors[msg.sender] > 0);

        address payable recipient = payable(msg.sender);
        uint value = contributors[msg.sender];
        recipient.transfer(value);

        //payable(msg.sender).transfer(contributors[msg.sender]);

        contributors[msg.sender] = 0;

    }

    modifier onlyAdmin(){
      require(msg.sender == admin,"only admin can call this function");
      _;  
    }

    function createRequest(string memory _desc,address payable _recipient,uint _value) public onlyAdmin{
        Request storage newRequest = requests[numRequests];
        numRequests++;

        newRequest.desc = _desc;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;

        emit CreateRequestEvent(_desc,_recipient,_value);
    } 

    function voteRequest(uint _requestNo) public{
        require(contributors[msg.sender] > 0,"You must be a contributor to vote");
        Request storage thisRequest = requests[_requestNo];

        require(thisRequest.voters[msg.sender] == false,"You have already voted!");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyAdmin{
        require(raisedAmt >= goal);
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false,"The request has been completed");
        require(thisRequest.noOfVoters > noOfContributors/2); //50% voted for this request

        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;

        emit MakePaymentEvent(thisRequest.recipient,thisRequest.value);
    }
}
