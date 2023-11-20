// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {DataTypes} from "../utils/DataTypes.sol";
import {SD59x18} from "prb/src/SD59x18.sol";

/**
 * @title IBSM
 * @author MoonaLisa
 *
 * @notice This is the interface for BlackScholesMertonStorage contract.
 */
interface IBSM {
    /**
     * @notice Black-Scholes-Merton formula for pricing European call and put options.
     *
     * @param isCall True if the option is a call, false if it is a put.
     * @param S The current price for 1 unit of the underlying asset.
     * @param K The strike price for 1 unit of the underlying asset.
     * @param T The time to maturity.
     * @param r The risk free premium rate.
     * @param v The annualized volatility.
     *
     */
    function BSMOptionPrice(
        bool isCall,
        SD59x18 S,
        SD59x18 K,
        SD59x18 T,
        SD59x18 r,
        SD59x18 v
    ) external returns (SD59x18);

    /**
     * @notice Cumulative distribution function (CDF) for a standard normal distribution
     *
     * @dev The function approximates the area under the curve of a standard normal distribution
     * It uses values that are pre-calculated to ensure the approximation is as accurate as possible
     * @param x The value to evaluate the CDF at.
     */
    function CDF(int256 x) external returns (SD59x18);
}
