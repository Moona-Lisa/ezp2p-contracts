// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Events} from "../utils/Events.sol";
import {DataTypes} from "../utils/DataTypes.sol";
import {Auth} from "../lib/Auth.sol";
import {ITokens} from "../interfaces/ITokens.sol";
import {TokensStorage} from "../storage/TokensStorage.sol";
import {AggregatorV3Interface} from "../lib/AggregatorV3Interface.sol";

/**
 * @title Tokens
 * @author MoonaLisa
 *
 * @notice This is the main entrypoint of the Tokens contract.
 */
abstract contract Tokens is Auth, ITokens, TokensStorage {
    /*//////////////////////////////////////////////////////////////
                                 PUBLIC
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc ITokens
    function addToken(
        DataTypes.CreateTokenParams memory params
    ) public onlyOwner {
        dataFeed = AggregatorV3Interface(params.priceFeedAddress);

        (, int price, , , ) = dataFeed.latestRoundData();

        tokensMap[params.tokenAddress] = token(
            params.name,
            params.tokenAddress,
            params.isAllowed,
            params.symbol,
            params.decimals,
            uint256(price),
            0,
            params.priceFeedAddress
        );

        tokensArr.push(params.tokenAddress);

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
    function updateTokensPrice() public onlyUpdater {
        for (uint i = 0; i < tokensArr.length; i++) {
            address tokenAddress = tokensArr[i];
            dataFeed = AggregatorV3Interface(
                tokensMap[tokenAddress].priceFeedAddress
            );

            (, int price, , , ) = dataFeed.latestRoundData();

            tokensMap[tokenAddress].currentPrice = uint256(price);
            emit Events.TokenPriceUpdated(tokenAddress, uint256(price));
        }
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
