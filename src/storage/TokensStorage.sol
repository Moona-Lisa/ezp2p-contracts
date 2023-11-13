// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../../lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

abstract contract TokensStorage {
    AggregatorV3Interface internal dataFeed;

    struct token {
        string name;
        address tokenAddress;
        bool isAllowed;
        string symbol;
        uint256 decimals;
        uint256 currentPrice;
        uint256 annualizedVolatility;
        address priceFeedAddress;
    }

    mapping(address => token) public tokensMap;
}
