// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library DataTypes {
    struct CreateOptionParams {
        string symbol;
        uint256 totalDurationInDays;
        uint256 amount1;
        uint256 amount2;
        uint256 premium;
        address asset1;
        address asset2;
        uint256 offerTimeInHours;
        uint256 exerciseTimeInHours;
        bool isCall;
    }

    struct CreateTokenParams {
        string name;
        address tokenAddress;
        bool isAllowed;
        string symbol;
        uint256 decimals;
        address priceFeedAddress;
        bool isStable;
    }
}
