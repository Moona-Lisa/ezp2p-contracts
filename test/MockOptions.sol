// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {Options} from "../src/core/Options.sol";
import {DataTypes} from "../src/utils/DataTypes.sol";
import {Events} from "../src/utils/Events.sol";
import {Utils} from "../src/utils/Utils.sol";

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

    function fulfillRequestMock(bytes memory response) public {
        if (response.length > 0) {
            // Parse the response and update the tokensMap
            address tokenAddr = Utils.str2addr(
                Utils.substring(string(response), 2, 44)
            );

            uint256 volValue = Utils.str2num(
                Utils.substring(string(response), 46, 50)
            );

            // require that the token exists
            require(
                tokensMap[tokenAddr].tokenAddress != address(0),
                "TOKEN NOT FOUND"
            );

            tokensMap[tokenAddr].annualizedVolatility = volValue;
            emit Events.TokenVolatilityUpdated(tokenAddr, volValue);
        }
    }

    function getVolValueMock() public view returns (bytes memory) {
        return s_lastResponse;
    }
}
