// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

abstract contract OptionsStorage {
    uint256 public totalOptions;

    struct Option {
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

    struct Buyer {
        address buyerAddress;
        bool hasExercised;
    }

    mapping(uint256 => bool) public claimMap;
    mapping(uint256 => Option) public optionsMap;

    mapping(uint256 => Buyer) public buyersMap;
}
