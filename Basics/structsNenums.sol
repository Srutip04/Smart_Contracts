pragma solidity >=0.5.0 <0.9.0;

// declaring a struct type outsite of a contract
// can be used in any contract declard in this file
struct Instructor{
    uint age;
    string name;
    address addr;
}

contract Academy{
    // declaring a state variable of type Instructor
  Instructor public acadIns;
 
   // declaring a new enum type
  enum State {Open ,Closed,Unkown}
  
  // declaring and initializing a new state variable of type State
  State public acadSt  =  State.Open;

 // initializing the struct in the constructor
  constructor(uint _age,string memory _name){
      acadIns.age = _age;
      acadIns.name = _name;
      acadIns.addr = msg.sender;
  }
   // changing a struct state variable
  function changeIns(uint _age,string memory _name, address _addr) public{
      if(acadSt == State.Open){
       Instructor memory myIns = Instructor({
          age: _age,
          name: _name,
          addr: _addr
      });

        acadIns = myIns; 
      }
      
  }
}

// the struct can be used in any contract declared in this file
contract School{
  Instructor public schoolIns;
}
