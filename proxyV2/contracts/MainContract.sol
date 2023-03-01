// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "./../interfaces/IUser.sol";

contract MainContract {
    address Owner;

    IUser contractImplementation;

    constructor() {
        Owner = msg.sender;
    }

    function upgradeTo(address _newImplementation) external {
        require(msg.sender == Owner, "Only owner can upgrade");
        contractImplementation = IUser(_newImplementation);
    }

    function getImplementation() external view returns (address) {
        return address(contractImplementation);
    }

    function getFirstName() external returns (string memory) {
        return contractImplementation.getFirstName();
    }

    function getLastName() external returns (string memory) {
        return contractImplementation.getLastName();
    }

    function setFirstName(string memory _firstName) external {
        contractImplementation.setFirstName(_firstName);
    }

    function setLastName(string memory _lastName) external {
        contractImplementation.setLastName(_lastName);
    }

}