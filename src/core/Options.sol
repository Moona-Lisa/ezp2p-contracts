// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Owner} from "../utils/Owner.sol";
import {OptionsStorage} from "../storage/OptionsStorage.sol";
import {IOptions} from "../interfaces/IOptions.sol";
import {DataTypes} from "../utils/DataTypes.sol";
import {Events} from "../utils/Events.sol";
import {Duration} from "../utils/Duration.sol";
import {ERC20} from "../utils/ERC20.sol";

/**
 * @title Options
 * @author MoonaLisa
 *
 * @notice This is the main entrypoint of the Options contract.
 */
contract Options is Owner, OptionsStorage, IOptions {
    /*//////////////////////////////////////////////////////////////
                                 CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {
        totalOptions = 0;
    }

    /*//////////////////////////////////////////////////////////////
                                 PUBLIC
    //////////////////////////////////////////////////////////////*/
    /// @inheritdoc IOptions
    function addToken(
        string memory name,
        address tokenAddress,
        bool isAllowed,
        string memory symbol,
        uint256 decimals
    ) public onlyOwner {
        tokensMap[tokenAddress] = token(
            name,
            tokenAddress,
            isAllowed,
            symbol,
            decimals
        );

        emit Events.AddToken(name, tokenAddress, isAllowed, symbol);
    }

    /// @inheritdoc IOptions
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

    /// @inheritdoc IOptions
    function createOption(
        DataTypes.CreateOptionParams memory params
    ) public payable {
        require(
            tokensMap[params.asset1].tokenAddress != address(0),
            "ASSET1 NOT FOUND"
        );
        require(
            tokensMap[params.asset2].tokenAddress != address(0),
            "ASSET2 NOT FOUND"
        );
        require(tokensMap[params.asset1].isAllowed, "ASSET1 NOT ALLOWED");
        require(tokensMap[params.asset2].isAllowed, "ASSET2 NOT ALLOWED");
        require(params.amount > 0, "AMOUNT MUST BE POSITIVE");
        require(params.nbOfDays > 3, "DURATION MUST BE MORE THAN 3 DAYS");
        require(
            params.offerExpiryAfterHours > 0,
            "OFFER EXPIRY TIME MUST BE POSITIVE"
        );
        require(
            params.exerciseTimeInHours > 0,
            "EXERCISE TIME MUST BE POSITIVE"
        );

        uint256 endTime = Duration.getDurationEndTimeForDays(
            block.timestamp,
            params.nbOfDays
        );
        uint256 offerExpiryTime = Duration.getDurationEndTimeForHours(
            block.timestamp,
            params.offerExpiryAfterHours
        );
        uint256 exerciseTime = Duration.getDurationStartTimeForHours(
            endTime,
            params.exerciseTimeInHours
        );

        require(
            offerExpiryTime < exerciseTime,
            "OFFER EXPIRY TIME MUST BE BEFORE EXERCISE TIME"
        );

        // Approve the transfer of asset1
        require(
            ERC20(params.asset1).approve(address(this), params.amount),
            "ASSET1 APPROVAL FAILED"
        );

        require(
            ERC20(params.asset1).transferFrom(
                msg.sender,
                address(this),
                params.amount
            ),
            "ASSET1 TRANSFER FAILED"
        );

        option memory newOption = option(
            msg.sender,
            params.symbol,
            block.timestamp,
            endTime,
            params.strikePrice,
            params.amount,
            params.asset1,
            params.asset2,
            true, //iscall TODO: check on price and strike price
            offerExpiryTime,
            exerciseTime,
            false
        );

        totalOptions++;
        optionsMap[totalOptions] = newOption;

        emit Events.OptionCreated(
            totalOptions,
            msg.sender,
            params.symbol,
            block.timestamp,
            endTime,
            params.strikePrice,
            params.amount,
            params.asset1,
            params.asset2,
            true, //iscall TODO: check on price and strike price
            offerExpiryTime,
            exerciseTime
        );
    }
}
