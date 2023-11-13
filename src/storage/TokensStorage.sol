// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

abstract contract TokensStorage {
    struct token {
        string name;
        address tokenAddress;
        bool isAllowed;
        string symbol;
        uint256 decimals;
        uint256 currentPrice;
        uint256 annualizedVolatility;
    }

    mapping(address => token) public tokensMap;
}
