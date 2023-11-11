// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library DataTypes {
    struct CreateOptionParams {
        string symbol;
        uint256 nbOfDays;
        uint256 strikePrice;
        uint256 amount;
        address asset1;
        address asset2;
        uint256 offerExpiryAfterHours;
        uint256 exerciseTimeInHours;
        bool isCall;
    }
}
