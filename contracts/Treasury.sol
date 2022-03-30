// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "hardhat/console.sol";

contract Treasury { 
    address public treasuryOwner;
    uint256 public goalToReach;
    mapping(address => uint256) depositedMoneyByAccount;


    constructor(){
        treasuryOwner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == treasuryOwner, "Only the owner of the contract is allowed to execute this");
        _;
    }

    event NewTransaction(address indexed from, uint timestamp, uint256 amount, string transactionType);

    struct Deposition {
        address user;
        uint256 amount;
        uint256 timestamp;
        string transactionType;
    }

    Deposition[] depositions;

    function setGoalToReach(uint256 _goal) external onlyOwner{
        goalToReach = _goal;
    }

    function depositMoney() public payable {
        require(msg.value != 0, "You need to deposit some amount of money!");
        depositedMoneyByAccount[msg.sender] += msg.value;

        depositions.push(Deposition(msg.sender, msg.value, block.timestamp, "Deposition"));

        emit NewTransaction(msg.sender, block.timestamp, msg.value, "Deposition");
    }

    function getTreasuryAccountBalance() external view returns(uint256){
        return address(this).balance;
    }

    function sendToOwner() public payable onlyOwner{
        require(
             address(this).balance < goalToReach,
            "Goal not reached yet");

        (bool sent, ) = treasuryOwner.call {value: address(this).balance}("");

        require(sent, "Transaction failed");

         depositions.push(Deposition(treasuryOwner, address(this).balance, block.timestamp, "Withdrawal"));

        emit NewTransaction(treasuryOwner, block.timestamp, address(this).balance, "Withdrawal");
    }

    function userContribution() external view returns(uint256){
        return depositedMoneyByAccount[msg.sender];
    }
}
