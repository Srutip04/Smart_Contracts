pragma solidity >=0.5.0 <0.9.0;

contract OnOffSwitch{
    bool public isOn;

    constructor() public{
        isOn=true;
    }

    function toggle() public returns(bool){
        isOn = !isOn;
        return isOn;
    }
}
