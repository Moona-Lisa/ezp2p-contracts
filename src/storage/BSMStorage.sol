// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SD59x18, sd} from "prb/src/SD59x18.sol";

abstract contract BSMStorage {
    // Coefficients of a polynomial derived from a a series expansion
    SD59x18 internal B1 = sd(0.31938153e18);
    SD59x18 internal B2 = sd(-0.356563782e18);
    SD59x18 internal B3 = sd(1.781477937e18);
    SD59x18 internal B4 = sd(-1.821255978e18);
    SD59x18 internal B5 = sd(1.330274429e18);

    // Coefficient used for adjusting the rate for the cumulative probability
    SD59x18 internal P = sd(0.2316419e18);

    // Coefficient for the normalization factor of the Gaussian function
    SD59x18 internal C = sd(0.39894228e18);
}
