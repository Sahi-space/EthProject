# SimpleBank

SimpleBank is a basic Solidity smart contract that allows users to deposit Ether, transfer Ether to other accounts, and check their balances. The contract includes mechanisms for safe Ether transfers, ensuring that transactions are properly reverted in case of failure.

## Description

This smart contract demonstrates the use of error handling with `require`, `assert`, and `revert` for various bank functions. It includes a `deposit` function to add Ether to a user's balance, a `transfer` function to send Ether to another account, and functions to check the balance of the caller or any specified account. The contract ensures robust error handling to maintain data integrity and security. `require` is used to validate conditions before executing critical operations, `assert` is used to check for conditions that should never fail, and `revert` is used to undo changes if an operation fails, providing a detailed error message.
## Features

- **Deposit Ether**: Users can deposit Ether into the bank.
- **Transfer Ether**: Users can transfer Ether to another account within the bank.
- **Check Balance**: Users can check their own balance.
- **Admin Balance Check**: The owner can check the balance of any account.

## Getting Started

### Executing program

To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension (e.g., SimpleBank.sol). Copy and paste the following code into the file:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

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


```

To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.26" (or another compatible version), and then click on the "Compile Bank.sol" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the "SimpleBank" contract from the dropdown menu, and then click on the "Deploy" button.

Once the contract is deployed, you can interact with it by calling the calling deposit function for an address and use call the getBalance function to check the deposited amount. 

## Interacting with the Smart Contract

### Contract Variables

- `balances`: A mapping that stores the balance of each user.
- `owner`: The address of the contract owner.

### Events

- `Withdrawal`: Emitted when a withdrawal is made.
- `Transfer`: Emitted when a transfer is made.

### Constructor

The constructor sets the contract deployer as the owner.

### Functions

#### `deposit()`

- **Description**: Allows users to deposit Ether into the bank.
- **Visibility**: `public` and `payable`
- **Requirements and error handling**:
  - The deposit amount must be greater than zero.

#### `transfer(address to)`

- **Description**: Allows users to transfer Ether to another account within the bank.
- **Visibility**: `public` and `payable`
- **Requirements**:
  - The transfer amount must be greater than zero.
  - The sender must have a sufficient balance.
- **Error Handling**:
  - If the transfer fails, the transaction is reverted, and the deducted amount is refunded.

#### `getBalance()`

- **Description**: Returns the balance of the caller.
- **Visibility**: `public` and `view`

#### `getBalanceOf(address account)`

- **Description**: Allows the owner to check the balance of any account.
- **Visibility**: `public` and `view`
- **Requirements**:
  - Only the owner can call this function.

## Authors

Sahitya Pandey 

## License

This project is licensed under the MIT License - see the LICENSE.md file for details
