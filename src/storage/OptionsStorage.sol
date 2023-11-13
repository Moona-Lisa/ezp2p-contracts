// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

abstract contract OptionsStorage {
    uint256 public totalOptions;

    struct option {
        address creator;
        string symbol;
        uint256 endTime;
        uint256 strikePrice;
        uint256 totalAmount;
        uint256 premiumPrice;
        address asset1;
        address asset2;
        bool isCall;
        uint256 offerExpiryTime;
        uint256 exerciseStartTime;
    }

    struct buyer {
        address buyerAddress;
        bool hasExercised;
    }

    mapping(uint256 => bool) public claimMap;
    mapping(uint256 => option) public optionsMap;

    mapping(uint256 => buyer) public buyersMap;
}
