# Shared Item Management
This project is an example of a smart contract developed using the Solidity programming language. 
The "Shared Item Management" smart contract is designed to manage operations such as listing, renting, and returning items.

# Contents
* Project Description
* Installation
* Usage
* Tests
* License

  
# Project Description
This smart contract enables the renting of items shared by their owners. 
The owner of an item defines details like its name and rental price. 
Users interested in renting the item can do so by paying the specified rental fee. 
Once the rental period expires, payment is made to the item's owner, and the item becomes available for rent again.

# Installation
You can run this project on your local machine by following these steps:

1. Clone the project:
```<bash>
git clone https://github.com/cptmfs/SharedItemManagement_SmartContract.git
```
2. Navigate to the project directory:
```<bash>
cd shared-item-management
```
3. Install the required dependencies:
```<bash>
npm install
```
# Usage
1. Review the <b>'SharedItemManagement.sol'</b> smart contract in the contracts directory. This <b>'contract'</b> contains the necessary functions for managing shared items.

2. Examine the <b>'TestSharedItemManagement.sol'</b> file in the test directory. This file contains <b>'tests for'</b> the smart contract.

3. Compile the smart contract using the following command:
```<bash>
truffle compile
```
4. Migrate the smart contract:

```<bash>
truffle migrate
```
# Tests
To run tests for the project:
```<bash>
truffle test
```
This command will test the functionality of the smart contract and display successful or unsuccessful outcomes.

# License
This project is licensed under the MIT License. For more information, refer to the LICENSE file.

For more information about the project, visit the <a href="https://github.com/cptmfs/SharedItemManagement_SmartContract" target="_blank">Shared Item Management</a> GitHub repository.

# Smart Contract
If you want to review and use the contract, you can access it from the <a href="https://testnet.bscscan.com/address/0x7bbb8720c226811c522833adc0eec5b7f559b17e" target="_blank">Smart Contract</a> link.
