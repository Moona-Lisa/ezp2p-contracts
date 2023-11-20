// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {Options} from "../src/core/Options.sol";
import {DataTypes} from "../src/utils/DataTypes.sol";
import {Events} from "../src/utils/Events.sol";
import {Utils} from "../src/utils/Utils.sol";
import {FunctionsRequest} from "chainlink/contracts/src/v0.8/functions/dev/v1_0_0/libraries/FunctionsRequest.sol";

contract MockOptions is Options {
    using FunctionsRequest for FunctionsRequest.Request;

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
                Utils.substring(string(response), 11, 53)
            );

            uint256 volValue = Utils.str2num(
                Utils.substring(string(response), 70, 74)
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

    function updateTokensVolatilityMock()
        public
        onlyUpdater
        returns (uint64, string[] memory)
    {
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
            (uint64 t, string[] memory y) = sendRequestMock(
                786,
                strigifiedAddr
            );
            return (t, y);
        }
    }

    function sendRequestMock(
        uint64 subscriptionId,
        string[] memory args
    ) public onlyOwner returns (uint64, string[] memory) {
        require(args.length > 0);
        return (subscriptionId, args);
    }
}
