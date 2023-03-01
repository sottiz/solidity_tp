// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "./../interfaces/IUser.sol";

contract User is IUser{
    IUser.User user;

    function getFirstName() override(IUser) external view returns (string memory) {
        return user.firstName;
    }

    function getLastName() override(IUser) external view returns (string memory) {
        return user.lastName;
    }

    function setFirstName(string memory _firstName) override(IUser) external {
        user.firstName = _firstName;
    }

    function setLastName(string memory _lastName) override(IUser) external {
        user.lastName = _lastName;
    }
}