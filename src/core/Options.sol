// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {OptionsStorage} from "../storage/OptionsStorage.sol";
import {IOptions} from "../interfaces/IOptions.sol";
import {Tokens} from "../utils/Tokens.sol";
import {DataTypes} from "../utils/DataTypes.sol";
import {Events} from "../utils/Events.sol";
import {Utils} from "../utils/Utils.sol";
import {ERC20} from "../lib/ERC20.sol";

/**
 * @title Options
 * @author MoonaLisa
 *
 * @notice This is the main entrypoint of the Options contract.
 */
contract Options is OptionsStorage, IOptions, Tokens {
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
    function exerciseOption(uint256 optionId) public {
        require(msg.sender != address(0), "INVALID ADDRESS");
        Option memory optionToExercise = optionsMap[optionId];
        require(optionToExercise.creator != address(0), "OPTION NOT FOUND");
        Buyer memory buyer = buyersMap[optionId];
        require(!buyer.hasExercised, "ALREADY EXERCISED");
        require(
            buyersMap[optionId].buyerAddress != address(0),
            "NOT BOUGHT YET"
        );
        require(
            block.timestamp > optionToExercise.exerciseStartTime,
            "NOT EXERCISABLE"
        );
        require(block.timestamp < optionToExercise.endTime, "HAS EXPIRED");
        require(buyer.buyerAddress == msg.sender, "NOT YOUR OPTION");

        require(
            ERC20(optionToExercise.asset2).balanceOf(msg.sender) >=
                optionToExercise.amount2,
            "INSUFFICIENT TOKEN BALANCE"
        );
        require(
            ERC20(optionToExercise.asset2).allowance(
                msg.sender,
                address(this)
            ) >= optionToExercise.amount2,
            "INSUFFICIENT TOKEN ALLOWANCE"
        );

        require(
            ERC20(optionToExercise.asset2).transferFrom(
                msg.sender,
                optionToExercise.creator,
                optionToExercise.amount2
            ),
            "ASSET2 TRANSFER FAILED"
        );
        require(
            ERC20(optionToExercise.asset1).transfer(
                msg.sender,
                optionToExercise.amount1
            ),
            "ASSET1 TRANSFER FAILED"
        );

        buyersMap[optionId].hasExercised = true;
        emit Events.OptionExercised(optionId, msg.sender);
    }

    /// @inheritdoc IOptions
    function buyOption(uint256 optionId) public virtual {
        require(msg.sender != address(0), "INVALID ADDRESS");
        Option memory optionToBuy = optionsMap[optionId];
        require(optionToBuy.creator != address(0), "OPTION NOT FOUND");
        require(optionToBuy.offerExpiryTime > block.timestamp, "OFFER EXPIRED");
        require(
            buyersMap[optionId].buyerAddress == address(0),
            "ALREADY BOUGHT"
        );

        //  premium is in usdc token
        require(
            ERC20(address(0xCaC7Ffa82c0f43EBB0FC11FCd32123EcA46626cf))
                .balanceOf(msg.sender) >= optionToBuy.premium,
            "INSUFFICIENT TOKEN BALANCE"
        );
        require(
            ERC20(address(0xCaC7Ffa82c0f43EBB0FC11FCd32123EcA46626cf))
                .allowance(msg.sender, address(this)) >= optionToBuy.premium,
            "INSUFFICIENT TOKEN ALLOWANCE"
        );

        require(
            ERC20(address(0xCaC7Ffa82c0f43EBB0FC11FCd32123EcA46626cf))
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
                params.amount1
            ),
            "ASSET1 TRANSFER FAILED"
        );

        Option memory newOption = Option(
            msg.sender,
            params.symbol,
            endTime,
            params.amount1,
            params.amount2,
            params.premium,
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
            endTime,
            params.amount1,
            params.amount2,
            params.premium,
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
        require(params.amount1 > 0, "AMOUNT1 MUST BE POSITIVE");
        require(params.amount2 > 0, "AMOUNT2 MUST BE POSITIVE");
        require(
            params.totalDurationInDays > 3,
            "DURATION MUST BE MORE THAN 3 DAYS"
        );
        require(
            params.offerTimeInHours > 0,
            "OFFER EXPIRY TIME MUST BE POSITIVE"
        );
        require(
            params.exerciseTimeInHours > 0,
            "EXERCISE TIME MUST BE POSITIVE"
        );
        require(params.premium > 0, "PREMIUM MUST BE POSITIVE");

        uint256 endTime = Utils.getDurationEndTimeForDays(
            block.timestamp,
            params.totalDurationInDays
        );
        uint256 offerExpiryTime = Utils.getDurationEndTimeForHours(
            block.timestamp,
            params.offerTimeInHours
        );
        uint256 exerciseTime = Utils.getDurationStartTimeForHours(
            endTime,
            params.exerciseTimeInHours
        );

        require(
            offerExpiryTime < exerciseTime,
            "OFFER EXPIRY TIME MUST BE BEFORE EXERCISE TIME"
        );

        require(
            ERC20(params.asset1).allowance(msg.sender, address(this)) >=
                params.amount1,
            "INSUFFICIENT TOKEN ALLOWANCE"
        );

        require(
            ERC20(params.asset1).balanceOf(msg.sender) >= params.amount1,
            "INSUFFICIENT TOKEN BALANCE"
        );

        return (endTime, offerExpiryTime, exerciseTime);
    }

    function claimCollateral(uint256 optionId) public {
        require(msg.sender != address(0), "INVALID ADDRESS");
        require(!claimMap[optionId], "ALREADY CLAIMED");
        Option memory optionToClaim = optionsMap[optionId];
        require(optionToClaim.creator != address(0), "OPTION NOT FOUND");
        require(
            optionToClaim.offerExpiryTime < block.timestamp,
            "OFFER NOT EXPIRED YET"
        );

        if (optionToClaim.endTime > block.timestamp) {
            require(
                buyersMap[optionId].buyerAddress == address(0),
                "OPTION IS BOUGHT"
            );
        } else {
            require(!buyersMap[optionId].hasExercised, "OPTION IS EXERCISED");
        }

        require(
            ERC20(optionToClaim.asset1).transfer(
                optionToClaim.creator,
                optionToClaim.amount1
            ),
            "ASSET1 TRANSFER FAILED"
        );
        claimMap[optionId] = true;
        emit Events.AssetClaimed(msg.sender, optionId, optionToClaim.amount1);
    }
}
