pragma solidity >=0.5.0 <0.9.0;

struct Instructor{
    uint age;
    string name;
    address addr;
}

contract Academy{
  Instructor public acadIns;

  enum State {Open ,Closed,Unkown}
  State public acadSt  =  State.Open;

  constructor(uint _age,string memory _name){
      acadIns.age = _age;
      acadIns.name = _name;
      acadIns.addr = msg.sender;
  }

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

contract School{
  Instructor public schoolIns;
}