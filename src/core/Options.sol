// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Owned} from "../lib/Owned.sol";
import {OptionsStorage} from "../storage/OptionsStorage.sol";
import {IOptions} from "../interfaces/IOptions.sol";
import {DataTypes} from "../utils/DataTypes.sol";
import {Events} from "../utils/Events.sol";
import {Duration} from "../utils/Duration.sol";
import {ERC20} from "../lib/ERC20.sol";

/**
 * @title Options
 * @author MoonaLisa
 *
 * @notice This is the main entrypoint of the Options contract.
 */
contract Options is Owned, OptionsStorage, IOptions {
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
    function createOption(DataTypes.CreateOptionParams memory params) public {
        (
            uint256 endTime,
            uint256 offerExpiryTime,
            uint256 exerciseTime
        ) = checkCreateOption(params);

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
            params.isCall,
            offerExpiryTime,
            exerciseTime
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
            params.isCall,
            offerExpiryTime,
            exerciseTime
        );
    }

    /*//////////////////////////////////////////////////////////////
                              PUBLIC VIEW
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IOptions
    function checkCreateOption(
        DataTypes.CreateOptionParams memory params
    ) public view returns (uint256, uint256, uint256) {
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

        require(
            ERC20(params.asset1).allowance(msg.sender, address(this)) >=
                params.amount,
            "INSUFFICIENT TOKEN ALLOWANCE"
        );

        require(
            ERC20(params.asset1).balanceOf(msg.sender) >= params.amount,
            "INSUFFICIENT TOKEN BALANCE"
        );

        return (endTime, offerExpiryTime, exerciseTime);
    }
}
