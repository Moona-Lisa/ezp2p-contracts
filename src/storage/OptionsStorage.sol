// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

abstract contract OptionsStorage {
    uint256 public totalOptions;

    struct option {
        address creator;
        string symbol;
        uint256 startTime;
        uint256 endTime;
        uint256 strikePrice;
        uint256 totalAmount;
        address asset1;
        address asset2;
        bool isCall;
        uint256 offerExpiryTime;
        uint256 exerciseStartTime;
        bool isClaimed;
    }

    struct token {
        string name;
        address tokenAddress;
        bool isAllowed;
        string symbol;
        uint256 decimals;
    }

    mapping(uint256 => option) public optionsMap;
    mapping(address => token) public tokensMap;
}
