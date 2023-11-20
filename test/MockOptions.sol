// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {Options} from "../src/core/Options.sol";
import {DataTypes} from "../src/utils/DataTypes.sol";
import {Events} from "../src/utils/Events.sol";
import {Utils} from "../src/utils/Utils.sol";
import {FunctionsRequest} from "chainlink/contracts/src/v0.8/functions/dev/v1_0_0/libraries/FunctionsRequest.sol";
import {ERC20} from "../src/lib/ERC20.sol";

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
        view
        onlyUpdater
        returns (uint64 x, string[] memory y)
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
            (x, y) = sendRequestMock(786, strigifiedAddr);
            return (x, y);
        }
    }

    function sendRequestMock(
        uint64 subscriptionId,
        string[] memory args
    ) public view onlyOwner returns (uint64, string[] memory) {
        require(args.length > 0);
        return (subscriptionId, args);
    }

    function buyOption(uint256 optionId) public override {
        require(msg.sender != address(0), "INVALID ADDRESS");
        Option memory optionToBuy = optionsMap[optionId];
        require(optionToBuy.creator != address(0), "OPTION NOT FOUND");
        require(optionToBuy.offerExpiryTime > block.timestamp, "OFFER EXPIRED");
        require(
            buyersMap[optionId].buyerAddress == address(0),
            "ALREADY BOUGHT"
        );

        //  premium is in mock usdc token
        require(
            ERC20(address(0x5991A2dF15A8F6A256D3Ec51E99254Cd3fb576A9))
                .balanceOf(msg.sender) >= optionToBuy.premium,
            "INSUFFICIENT TOKEN BALANCE"
        );
        require(
            ERC20(address(0x5991A2dF15A8F6A256D3Ec51E99254Cd3fb576A9))
                .allowance(msg.sender, address(this)) >= optionToBuy.premium,
            "INSUFFICIENT TOKEN ALLOWANCE"
        );

        require(
            ERC20(address(0x5991A2dF15A8F6A256D3Ec51E99254Cd3fb576A9))
                .transferFrom(
                    msg.sender,
                    optionToBuy.creator,
                    optionToBuy.premium
                ),
            "ASSET2 TRANSFER FAILED"
        );

        buyersMap[optionId] = Buyer(msg.sender, false);

        emit Events.OptionBought(optionId, msg.sender);
    }
}
