// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {DataTypes} from "../utils/DataTypes.sol";

/**
 * @title IOptions
 * @author MoonaLisa
 *
 * @notice This is the interface for the Options contract.
 */
interface IOptions {
    /**
     * @notice Adds a token to the whitelist.
     *
     * @param name The name of the token.
     * @param tokenAddress The address of the token.
     * @param isAllowed Whether the token is allowed or not.
     * @param symbol The symbol of the token.
     */
    function addToken(
        string memory name,
        address tokenAddress,
        bool isAllowed,
        string memory symbol,
        uint256 decimals
    ) external;

    /**
     * @notice Allows or disallows a token.
     *
     * @param tokenAddress The address of the token.
     * @param status Whether the token is allowed or not.
     */
    function allowToken(address tokenAddress, bool status) external;

    /**
     * @notice Checks if the option can be created.
     *
     * @param params The parameters of the option.
     *
     * @return endTime The end time of the option.
     * @return offerExpiryTime The offer expiry time of the option.
     * @return exerciseTime The exercise time of the option.
     */
    function checkCreateOption(
        DataTypes.CreateOptionParams memory params
    ) external returns (uint256, uint256, uint256);

    /**
     * @notice Creates an option.
     *
     * @param params The parameters of the option.
     */
    function createOption(DataTypes.CreateOptionParams memory params) external;
}
