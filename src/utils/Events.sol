// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/**
 * @title Events
 * @author MoonaLisa
 *
 * @notice Holds all the events emitted by the contracts.
 */
library Events {
    event AddToken(
        string name,
        address tokenAddress,
        bool isAllowed,
        string symbol
    );

    event AllowToken(address tokenAddress, bool status);

    event OptionCreated(
        uint256 indexed optionId,
        address indexed creator,
        string symbol,
        uint256 startTime,
        uint256 endTime,
        uint256 strikePrice,
        uint256 amount,
        address asset1,
        address asset2,
        bool isCall,
        uint256 offerExpiryTime,
        uint256 exerciseTime
    );

    event AssetClaimed(
        address indexed claimant,
        uint256 indexed optionId,
        uint256 claimedAmount
    );
}
