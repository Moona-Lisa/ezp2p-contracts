// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {Options} from "../src/core/Options.sol";
import {DataTypes} from "../src/utils/DataTypes.sol";
import {Events} from "../src/utils/Events.sol";

contract MockOptions is Options {
    function addToken(
        DataTypes.CreateTokenParams memory params
    ) public override onlyOwner {
        tokensMap[params.tokenAddress] = Token(
            params.name,
            params.tokenAddress,
            params.isAllowed,
            params.symbol,
            params.decimals,
            0,
            0,
            params.priceFeedAddress,
            params.isStable
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
}
