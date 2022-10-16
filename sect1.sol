// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

// Used to convert uint to string
import "@openzeppelin/contracts/utils/Strings.sol";

contract TestContract{

    // ----- VARIABLES ----- 
    // Begin with a letter or underscore and can also contain numbers

    // State : Values are permanently stored in contract storage and is available
    // to all functions in the contract
    // Local : Values available only in the function in which they are defined
    // Global : Provide info about the blockchain and are built into Solidity
    // A Private variable can only be called within the contract

    // ----- DATA TYPES -----
    // Booleans are true or false
    // State variable that is accessible outside of the contract because
    // of public
    bool public canVote = true; 

    // Integers store signed and unsigned whole numbers
    // Private so can only be accessed in the contract
    int private myAge = 47;

    // Unsigned Integers (You Ints) start as uint8 and increase to uint256
    // in increments of 8
    // You also have uint8, uint16, uint32, ...
    // An internal variable can only be accessed in the contract
    // or by contracts that inherit from this one
    uint internal favNum = 3;

    // If you want to use numbers bigger than 256 bits, or floating
    // points you have to emulate them. There are libraries that
    // do but they lack standardized number formats
    // Because Solidity concerns itself with finance values must
    // be exact and since floats aren't exact we can't use them
    // as we do with other languages
    
    // Strings 
    string myName = "Derek";

    // Used to initialize contract variables (More on them later) 
    constructor(){}

    // ----- CASTING UINT & BYTES -----
    // We want to reduce our computational expenses by using
    // the correctly sized uint

    // A uint is 256 bit unsigned integer by default
    // uint 256 : Max size 1.15792089 x 10^77
    // uint8 : 2^8 - 1 : 255
    // uint16 : 2^16 - 1 : 65,535
    // uint32 : 2^32 - 1 : 4,294,967,295

    // We convert by putting the value to convert inside parentheses
    // with the type to convert to before
    uint toBig = 250;
    uint8 justRight = uint8(toBig);

    // ----- ETHER UNITS -----
    // Ether is the currency of the Ethereum blockchain
    // Wei is the smallest denomination of Ether
    // 1 Ether = 10^18 Wei (Way)
    // 1 Ether = 1,000,000,000 Gwei
    // 1 Ether = 1,000 Finney
    // We need this many zeroes because $1 == .00032 Ethereum

    // ----- FUNCTIONS ----- 
    // function funcName(parameterList) scope returns() {statements}
    
    // Create a function and define parameters it receives
    // We are stating to store the arguments in memory

    // Arguments are either passed by VALUE : Value changes in function
    // don't effect the value outside of it
    // Or, by REFERENCE : changes in function effect value outside

    // Function variables should start with an underscore to 
    // differentiate them from global variables

    // ----- SCOPE -----
    // 1. Public functions are excessible by other contracts
    // 2. Private functions are only accessible to code that is in the contract
    // Private function names begin with _
    // 3. External functions can't be called by the contract, but can be
    // called outside of the contract
    // 4. Internal functions are only accessible within the contract or by
    // other contracts that inherit from this contract

    // A VIEW function works with data and allows us to view the
    // results of the function (Won't modify the state)
    // A PURE function doesn't allow reading or modifying state

    // This function returns a uint
    // Since it doesn't return a state value but instead a 
    // calculation it is marked as pure
    function getSum(uint _num1, uint _num2) public pure returns (uint) {
        // Variables created in a function are only available in
        // the function : Local Variables
        uint _mySum = _num1 + _num2;
        return _mySum;
    }

    function getResult() public pure returns(uint){
        uint a = 10;
        uint b = 5;
        uint result = a + b;
        return result;
    }

    uint specialVal = 10;

    // External means it can only be called from outside the contract
    // but not from within (We can change state variables)
    function changeSV(uint _val) external {
        specialVal = _val;
    }

    // View needed to return the value but restrict changing it
    function getSV() external view returns(uint){
        return specialVal;
    }

    // ----- MATH OPERATORS -----
    // You can return multiple values
    function doMath(int _num1, int _num2) public pure returns(int, int, int,
    int, int, int){
        // If we want to require something to be true to continue
        // executing the function use require

        // ----- ERROR HANDLING -----
        // assert : If condition is false revert state changes (Uses up gas) 
        // require : If condition is false provides option to return message (Refunds Gas)
        // revert : Only sends back a message if condition in if statement calls it

        require(_num2 != 0, "2nd Number can't be Zero");

        // Assert will cancel execution also if the condition
        // isn't true
        assert(_num2 > 0);

        if(_num2 < 0){
            revert("2nd Number Must be Greater than 0");
        }

        // Assignment Operators : += -= *= /= %=
        // Increment : ++ Decrement : --
        int _add = _num1 + _num2;
        int _sub = _num1 - _num2;
        int _mult = _num1 * _num2;
        int _div = _num1 / _num2; // Integer division
        int _mod = _num1 % _num2;
        int _sqr = _num1 ** 2;
        return (_add, _sub, _mult, _div, _mod, _sqr);
    }

    // ----- GENERATE RANDOM NUMBER -----
    
    function getRandNum(uint _max) public view returns(uint){
        // Generate a pseudo-random hexadecimal using the hash function
        // keccak256 (K Chak) which takes an input and converts it into a random
        // 256 bit hexadecimal number
        // Perform packed encoding of the data before using it to generate 
        // the random value
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp)));

        // Takes result and returns values up to _max
        return rand % _max;
    }

    // ----- STRINGS -----
    // Printable ASCIII characters between single or double quotes
    // 
    string str1 = "Hello";

    // There are escape characters
    // \n \\ \' \" \r \t \xNN (Hex Escape) \uNNNN (Unicode)
    
    // Memory states that you want to temporarily store this string
    // data (Memory is deleted after each function execution)
    // Storage stores data between function calls
    function combineString(string memory _str1, string memory _str2) public pure returns (string memory){
        // Concat the 2 strings passed
        return string(abi.encodePacked(_str1, " ", _str2));
    }

    // Working with bytes saves computations versus working with strings
    // This function returns the number of characters in the string
    function numChars(string memory _str1) public pure returns(uint){
        // Convert string to bytes
        bytes memory _byte1 = bytes(_str1);
        return _byte1.length;
    }
    
    // ----- CONDITIONALS -----
    // Comparison Operators : == != > < >= <=
    // Logical Operators : && || !
    uint age = 8;
    
    // We are stating to store the arguments in memory
    function whatSchool() public view returns (string memory){
        if (age < 5) {
            return "Stay Home";
        } else if (age >= 5 && age <= 6){
            return "Go to Kindergarten";
        } else if (age >= 6 && age <= 17){
            uint _grade = age - 5;

            // Convert uint into a string
            string memory _gradeStr = Strings.toString(_grade);

            // Concat strings
            return string(abi.encodePacked("Grade ",_gradeStr));
        } else {
            return "Go to College";
        }
    }
     // ----- ARRAYS -----
    // Create an array that holds a dynamic number of values
    uint[] arr1;

    // Create fixed size array
    uint[10] arr2;

    // This creates an array of uints 5 in length
    uint [] public numList = [1,2,3,4,5];

    // Add 1, 2, 3, 4 to array
    function addToArray(uint num) public {
        // Add to end of array
        arr1.push(num);
    }

    // Array is now 1, 2, 3
    function removeFromArray() public {
        // Remove the last element
        arr1.pop();
    }

    // Length should be 3
    function getLength() public view returns (uint){
        // Get array length
        return arr1.length;
    }

    // If we pass 2 : 1, 2, 0
    function setIndexToZero(uint _index) public {
        // Sets value at specific index to 0
        // When you delete a value in an array the length 
        // stays the same
        delete arr1[_index];
    }

    // ----- FOR LOOP -----
    // Initialize starting index for loop
    // Define the loop length
    // How index value changes after each loop

    // If we pass 1 : 1, 0
    function removeIndex(uint _index) public {
        // Move the values up to replace the value to replace
        for(uint i = _index; i < arr1.length-1; i++){
            arr1[i] = arr1[i+1];
        }
        // Remove the last element
        arr1.pop();
    }

    // Get values in array
    function getArrayVals() public view returns (uint[] memory){
        return arr1;
    }
    
     // ----- FOR LOOP -----
    
    function sumNums() public view returns (uint){
        uint _sum = 0;
        
        for(uint i = 1; i <= numList.length; i++){
            _sum += numList[i];
        }
        return _sum;
    }

    // ----- WHILE LOOP -----
    function sumNums2() public view returns (uint){
        uint _i = 0;
        uint _sum = 0;
        while (_i < numList.length) {
            _sum += numList[_i];
            _i++;
        }
        return _sum;
    }
    
     // ----- STRUCTS -----
    // Create a data type that contains multiple variables

    struct Customer {
        string name;
        string custAddress;
        uint age;
    }

    Customer[] public customers;

    function addCust(string memory n, string memory ca, uint a) public {
        customers.push(Customer(n, ca, a));
    }

    function getCust(uint _index) public view returns (string memory n, string memory ca, uint a){
        Customer storage cust = customers[_index];
        return (cust.name, cust.custAddress, cust.age);
    }
    
     // ----- MAPPING -----
    // Allows you to create key / value pairs
    // The key can be a string, uint, or bool
    // Value can be anything

    mapping(string => string) public myMap;

    // Assigns key / value pair
    // If I add "Superman", "Clark Kent"
    function addSuper(string memory _secret, string memory _name) public {
        myMap[_secret] = _name;
    }

    // Returns value assigned to key
    // If sent "Superman" this returns "Clark Kent"
    function getName(string memory _secret) public view returns(string memory){
        return myMap[_secret];
    }

    function deleteName(string memory _secret) public {
        delete myMap[_secret];
    }
    
    // ----- STRUCTS & MAPPING -----
    mapping(uint => Customer) customer;

    // Map customer data to a index
    function addCust2(uint custID, string memory n, string memory ca, uint a) public {
        customer[custID] = Customer(n, ca, a);
    }

    // Retrieve customer data using an index
    function getCust2(uint _index) public view returns (string memory n, string memory ca, uint a)
    {    
        return (customer[_index].name, customer[_index].custAddress, customer[_index].age);
    }
    
    
   
}
