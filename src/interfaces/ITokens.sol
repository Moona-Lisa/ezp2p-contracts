// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {DataTypes} from "../utils/DataTypes.sol";

/**
 * @title ITokens
 * @author MoonaLisa
 *
 * @notice This is the interface for the Tokens contract.
 */
interface ITokens {
    /**
     * @notice Adds a token to the whitelist.
     *
     * @param params The parameters of the token.
     */
    function addToken(DataTypes.CreateTokenParams memory params) external;

    /**
     * @notice Allows or disallows a token.
     *
     * @param tokenAddress The address of the token.
     * @param status Whether the token is allowed or not.
     */
    function allowToken(address tokenAddress, bool status) external;

    /**
     * @notice Updates the price of a token.
     *
     * @param tokenAddress The address of the token.
     * @param currentPrice The current price of the token.
     */
    function updateTokenPrice(
        address tokenAddress,
        uint256 currentPrice
    ) external;

    /**
     * @notice Updates the annualized volatility of a token.
     *
     * @param tokenAddress The address of the token.
     * @param annualizedVolatility The annualized volatility of the token.
     */
    function updateTokenVolatility(
        address tokenAddress,
        uint256 annualizedVolatility
    ) external;
}
