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
     */
    function updateTokensPrice() external;

    /**
     * @notice Updates the volatility of a token.
     *
     */
    function updateTokensVolatility() external;
}
