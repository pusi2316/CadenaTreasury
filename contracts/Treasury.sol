// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "hardhat/console.sol";

contract Treasury {    
    address treasuryOwner;
    uint256 treasuryBalance;
    mapping(address => uint256) depositedMoneyByAccount;
    mapping(address => bool) public isConnectedToTreasury;

    constructor(){
        treasuryOwner = msg.sender;
    }

    event NewTransaction(address indexed from, uint timestamp, uint256 amount, string transactionType);

    struct Deposition {
        address user;
        uint256 amount;
        uint256 timestamp;
        string transactionType;
    }

    function joinToTreasury() external {
        isConnectedToTreasury[msg.sender] = true;
    }

    function depositMoney() public payable {
        require(msg.value != 0, "You need to deposit some amount of money!");
        treasuryBalance += msg.value;
        depositedMoneyByAccount[msg.sender] += msg.value;

        emit NewTransaction(msg.sender, block.timestamp, msg.value, "Deposition");
    }

    function getTreasuryAccountBalance() external view returns(uint256){
        return treasuryBalance;
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        require(
            _amount <= treasuryBalance,
            "You have insuffient funds to withdraw"
        );
        (bool sent, ) = _to.call {value: _amount}("");

        require(sent, "Transaction failed");
        treasuryBalance -= _amount;

        emit NewTransaction(msg.sender, block.timestamp, _amount, "Withdrawal");
    }

    function userContribution() external view returns(uint256){
        return depositedMoneyByAccount[msg.sender];
    }

    function IsConnected() external view returns(bool){
        return isConnectedToTreasury[msg.sender];
    }
}
