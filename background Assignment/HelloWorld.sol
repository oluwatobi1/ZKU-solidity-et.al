// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.1;

contract HelloWorld {
    // initialize variable helloworldNumber
    // variable is set to 0 by default
    uint256 helloWorldNumber = 7650;

    // this function return the latest value of helloWorldNumber
    // it reads of the value of network
    function retrieve() public view returns(uint256){
        return helloWorldNumber;
    }
    
    // Extra feature:this function can be used to change the value of helloWorldNumber
    function update(uint256 _helloWorldNumber) public {
        helloWorldNumber = _helloWorldNumber;
    }
}