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
     * @notice Exercises an option.
     *
     * @param optionId The id of the option.
     */
    function exerciseOption(uint256 optionId) external;

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

    /**
     * @notice Buys an option.
     *
     * @param optionId The id of the option.
     */
    function buyOption(uint256 optionId) external;

    /**
     * @notice Buys an option using CCIP.
     *
     * @param optionId The id of the option.
     * @param buyer The address of the buyer.
     * @param tokenAddr The address of the token.
     * @param amt The amount of the token.
     */
    function buyOptionCCIP(
        uint256 optionId,
        address buyer,
        address tokenAddr,
        uint256 amt
    ) external;

    /**
     * @notice Claim the collateral of an option.
     *
     * @param optionId The id of the option.
     */
    function claimCollateral(uint256 optionId) external;
}
