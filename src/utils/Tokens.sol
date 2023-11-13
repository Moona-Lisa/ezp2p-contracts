// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Events} from "../utils/Events.sol";
import {DataTypes} from "../utils/DataTypes.sol";
import {Auth} from "../lib/Auth.sol";
import {ITokens} from "../interfaces/ITokens.sol";
import {TokensStorage} from "../storage/TokensStorage.sol";

/**
 * @title Tokens
 * @author MoonaLisa
 *
 * @notice This is the main entrypoint of the Tokens contract.
 */
abstract contract Tokens is Auth, ITokens, TokensStorage {
    /// @inheritdoc ITokens
    function addToken(
        DataTypes.CreateTokenParams memory params
    ) public onlyOwner {
        tokensMap[params.tokenAddress] = token(
            params.name,
            params.tokenAddress,
            params.isAllowed,
            params.symbol,
            params.decimals,
            0,
            0
        );

        emit Events.AddToken(
            params.name,
            params.tokenAddress,
            params.isAllowed,
            params.symbol
        );
    }

    /// @inheritdoc ITokens
    function allowToken(address tokenAddress, bool status) public onlyOwner {
        require(
            tokensMap[tokenAddress].tokenAddress != address(0),
            "TOKEN NOT FOUND"
        );
        if (tokensMap[tokenAddress].isAllowed == status) {
            return;
        }
        tokensMap[tokenAddress].isAllowed = status;

        emit Events.AllowToken(tokenAddress, status);
    }

    /// @inheritdoc ITokens
    function updateTokenPrice(
        address tokenAddress,
        uint256 currentPrice
    ) public onlyUpdater {
        require(
            tokensMap[tokenAddress].tokenAddress != address(0),
            "TOKEN NOT FOUND"
        );
        tokensMap[tokenAddress].currentPrice = currentPrice;

        emit Events.TokenPriceUpdated(tokenAddress, currentPrice);
    }

    /// @inheritdoc ITokens
    function updateTokenVolatility(
        address tokenAddress,
        uint256 annualizedVolatility
    ) public onlyUpdater {
        require(
            tokensMap[tokenAddress].tokenAddress != address(0),
            "TOKEN NOT FOUND"
        );
        tokensMap[tokenAddress].annualizedVolatility = annualizedVolatility;

        emit Events.TokenVolatilityUpdated(tokenAddress, annualizedVolatility);
    }
}
