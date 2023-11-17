// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AggregatorV3Interface} from "../lib/AggregatorV3Interface.sol";

abstract contract TokensStorage {
    AggregatorV3Interface internal dataFeed;

    struct Token {
        string name;
        address tokenAddress;
        bool isAllowed;
        string symbol;
        uint256 decimals;
        uint256 currentPrice;
        uint256 annualizedVolatility;
        address priceFeedAddress;
        bool isStable;
    }

    mapping(address => Token) public tokensMap;
    address[] public tokensArr;
}
