// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "hardhat/console.sol";

contract Treasury { 
    address immutable public treasuryOwner;
    uint256 public goalToReach;
    mapping(address => uint256) depositedMoneyByAccount;


    constructor(){
        treasuryOwner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == treasuryOwner, "Only the owner of the contract is allowed to execute this");
        _;
    }

    event NewTransaction(address indexed from);

    function setGoalToReach(uint256 _goal) external onlyOwner{
        goalToReach = _goal;
    }

    function depositMoney() public payable {
        require(msg.value != 0, "You need to deposit some amount of money!");
        depositedMoneyByAccount[msg.sender] += msg.value;

        emit NewTransaction(msg.sender);
    }

    function getTreasuryAccountBalance() external view returns(uint256){
        return address(this).balance;
    }

    function sendToOwner() public payable onlyOwner{
        require(
             address(this).balance >= goalToReach,
            "Goal not reached yet");

        (bool sent, ) = treasuryOwner.call {value: address(this).balance}("");

        require(sent, "Transaction failed");

        emit NewTransaction(treasuryOwner);
    }

    function userContribution() external view returns(uint256){
        return depositedMoneyByAccount[msg.sender];
    }
}
