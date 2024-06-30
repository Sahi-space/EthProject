// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SimpleBank {
    mapping(address => uint) private balances;
    address public owner;

    // Event to log the withdrawal and transfer
    event Withdrawal(address indexed account, uint amount);
    event Transfer(address indexed from, address indexed to, uint amount);

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Function to deposit money into the bank
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;

        // Assert to ensure the balance was updated correctly
        assert(balances[msg.sender] >= msg.value);
    }

  
    // Function to transfer money to another account
    function transfer(address to) public payable{
        require(msg.value > 0, "Transfer amount must be greater than zero");
        uint balance = balances[msg.sender];
        require(balance >= msg.value, "Insufficient balance");

        // Deduct the amount from the sender's balance
        balances[msg.sender] -= msg.value;
        // Add the amount to the recipient's balance
        balances[to] += msg.value;

    (bool success, ) = msg.sender.call{value: msg.value}("");
        if (!success) {
            // Revert the transaction if transfer fails
            balances[msg.sender] += msg.value; // Refund the deducted amount
            revert("Transfer failed");
        }

        // Emit the transfer event
        emit Transfer(msg.sender, to, msg.value);

        // Assert to ensure the sender's balance is not negative
        assert(balances[msg.sender] >= 0);
        // Assert to ensure the recipient's balance is updated correctly
        assert(balances[to] >= msg.value);
    }

    // Function to get the balance of the caller
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    // Function to get the balance of any account (restricted to owner)
    function getBalanceOf(address account) public view returns (uint) {
        require(msg.sender == owner, "Only the owner can check other accounts' balances");
        return balances[account];
    }

   
}
