// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Owned {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() virtual {
        require(msg.sender == owner, "UNAUTHORIZED");
        _;
    }
}
