// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

interface IUser {
    struct User {
        string firstName;
        string lastName;
    }

    function getFirstName() external returns (string memory);
    function getLastName() external returns (string memory);

    function setFirstName(string memory _firstName) external;
    function setLastName(string memory _lastName) external;
}
