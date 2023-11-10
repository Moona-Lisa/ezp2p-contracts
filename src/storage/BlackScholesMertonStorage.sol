// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

abstract contract BlackScholesMertonStorage {
    // Coefficients of a polynomial derived from a a series expansion
    int256 internal constant B1 = 319381530000000000;
    int256 internal constant B2 = -356563782000000000;
    int256 internal constant B3 = 1781477937000000000;
    int256 internal constant B4 = -1821255978000000000;
    int256 internal constant B5 = 1330274429000000000;

    // Coefficient used for adjusting the rate for the cumulative probability
    int256 internal constant P = 231641900000000000;
    
    // Coefficient for the normalization factor of the Gaussian function
    int256 internal constant C = 398942280000000000;

    int256 internal constant ONE = 1e18;
    int256 internal constant TWO = 2 * ONE;
}