pragma solidity >=0.5.0 <0.9.0;

contract DynamicArray{
    uint[] public nos;

    function getLength() public view returns(uint){
        return nos.length;
    }

    function addEle(uint item) public{
        nos.push(item);
    }

    function getELe(uint i) public view returns(uint){
        if(i < nos.length){
            return nos[i];
        }
        return 0;
    }
    function popELe() public{
        nos.pop();
    }

    function f() public {
        // declaring a memory dynamic array
// it's not possible to resize memory arrays (push() and pop() are not available)
      uint[] memory y = new uint[](3);
      y[0]=10;
      y[1]=20;
      y[2]=30;
      nos = y;
    }
}