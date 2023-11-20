// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Events} from "../utils/Events.sol";
import {DataTypes} from "../utils/DataTypes.sol";
import {Auth} from "../lib/Auth.sol";
import {ITokens} from "../interfaces/ITokens.sol";
import {TokensStorage} from "../storage/TokensStorage.sol";
import {AggregatorV3Interface} from "../lib/AggregatorV3Interface.sol";
import {FunctionsConsumer} from "./FunctionsConsumer.sol";
import {Utils} from "../utils/Utils.sol";

/**
 * @title Tokens
 * @author MoonaLisa
 *
 * @notice This is the main entrypoint of the Tokens contract.
 */
abstract contract Tokens is Auth, ITokens, TokensStorage, FunctionsConsumer {
    /*//////////////////////////////////////////////////////////////
                                 PUBLIC
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc ITokens
    function addToken(
        DataTypes.CreateTokenParams memory params
    ) public virtual onlyOwner {
        dataFeed = AggregatorV3Interface(params.priceFeedAddress);

        int price;
        if (params.isStable) {
            price = 100000000;
        } else {
            (, price, , , ) = dataFeed.latestRoundData();
        }

        tokensMap[params.tokenAddress] = Token(
            params.name,
            params.tokenAddress,
            params.isAllowed,
            params.symbol,
            params.decimals,
            uint256(price),
            0,
            params.priceFeedAddress,
            params.isStable,
            0
        );

        tokensArr.push(params.tokenAddress);

        emit Events.AddToken(
            params.name,
            params.tokenAddress,
            params.isAllowed,
            params.symbol,
            params.isStable
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
            if (tokensMap[tokensArr[i]].isStable) {
                continue;
            }
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
    function updateTokensVolatility() public onlyUpdater {
        for (uint i = 0; i < tokensArr.length; i++) {
            if (tokensMap[tokensArr[i]].isStable) {
                continue;
            }

            address tokenAddress = tokensArr[i];

            // Initialize a string array with size 1
            string[] memory strigifiedAddr = new string[](1);

            // Convert the address to a string and store it in the array
            strigifiedAddr[0] = Utils.addr2str(tokenAddress);

            // Send the request with the stringified address
            sendRequest(786, strigifiedAddr);
        }
    }
}
