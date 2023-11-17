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
        string symbol,
        bool isStable
    );

    event TokenPriceUpdated(address tokenAddress, uint256 currentPrice);

    event TokenVolatilityUpdated(
        address tokenAddress,
        uint256 annualizedVolatility
    );

    event AllowToken(address tokenAddress, bool status);

    event OptionCreated(
        uint256 indexed optionId,
        address indexed creator,
        string symbol,
        uint256 endTime,
        uint256 strikePrice,
        uint256 amount,
        uint256 premiumPrice,
        address asset1,
        address asset2,
        bool isCall,
        uint256 offerExpiryTime,
        uint256 exerciseTime
    );

    event OptionBought(uint256 indexed optionId, address indexed buyer);
    event OptionExercised(uint256 indexed optionId, address indexed buyer);

    event AssetClaimed(
        address indexed claimant,
        uint256 indexed optionId,
        uint256 claimedAmount
    );

    event SetUpdaters(address[2] indexed authAddress);
}
