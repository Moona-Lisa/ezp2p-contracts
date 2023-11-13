// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {MockOptions} from "./MockOptions.sol";
import {DataTypes} from "../src/utils/DataTypes.sol";
import {ERC20} from "../src/lib/ERC20.sol";
import {MockERC20} from "./MockERC20.sol";

contract OptionsTest is Test {
    MockOptions public options;
    MockERC20 public token;

    // address public immutable owner;
    address constant alice = address(0xA11CE);
    address constant bob = address(0xB0B);

    DataTypes.CreateOptionParams public optionParams;
    DataTypes.CreateTokenParams public testTokenParams1;
    DataTypes.CreateTokenParams public testTokenParams2;

    function setUp() public {
        options = new MockOptions();
        token = new MockERC20("Token", "TKN", 18);
        optionParams = DataTypes.CreateOptionParams(
            "test",
            2,
            500,
            0,
            0,
            address(0x1351),
            address(token),
            0,
            0,
            true
        );

        testTokenParams1 = DataTypes.CreateTokenParams(
            "Token",
            address(0x1351),
            true,
            "test",
            18,
            address(0x1351)
        );
        testTokenParams2 = DataTypes.CreateTokenParams(
            "Token",
            address(token),
            true,
            "TKN",
            18,
            address(0x1351)
        );
    }

    function optionSetup() public {
        optionParams.amount = 5000;
        optionParams.nbOfDays = 4;
        optionParams.offerExpiryAfterHours = 24;
        optionParams.exerciseTimeInHours = 24;
        optionParams.asset1 = address(token);
        options.addToken(testTokenParams2);
        options.addToken(testTokenParams1);
        vm.warp(1620000000);
        token.mint(address(alice), 1e18);
        vm.prank(alice);
        token.approve(address(options), 5000);
        vm.prank(alice);
        options.createOption(optionParams);
    }

    /*//////////////////////////////////////////////////////////////
                          TEST CREATE OPTION
    //////////////////////////////////////////////////////////////*/

    // test createOption function with invalid params
    function test_createOptionInvalid() public {
        vm.expectRevert("ASSET1 NOT FOUND");
        vm.prank(alice);
        options.createOption(optionParams);

        options.addToken(testTokenParams1);
        vm.expectRevert("ASSET2 NOT FOUND");
        vm.prank(alice);
        options.createOption(optionParams);

        testTokenParams2.isAllowed = false;
        options.addToken(testTokenParams2);
        vm.expectRevert("ASSET2 NOT ALLOWED");
        vm.prank(alice);
        options.createOption(optionParams);

        options.allowToken(address(token), true);
        vm.expectRevert("AMOUNT MUST BE POSITIVE");
        vm.prank(alice);
        options.createOption(optionParams);

        optionParams.amount = 5000;
        vm.expectRevert("DURATION MUST BE MORE THAN 3 DAYS");
        vm.prank(alice);
        options.createOption(optionParams);

        optionParams.nbOfDays = 4;
        vm.expectRevert("OFFER EXPIRY TIME MUST BE POSITIVE");
        vm.prank(alice);
        options.createOption(optionParams);

        optionParams.offerExpiryAfterHours = 48;
        vm.expectRevert("EXERCISE TIME MUST BE POSITIVE");
        vm.prank(alice);
        options.createOption(optionParams);

        optionParams.exerciseTimeInHours = 60;
        vm.warp(1620000000);
        vm.expectRevert("OFFER EXPIRY TIME MUST BE BEFORE EXERCISE TIME");
        vm.prank(alice);
        options.createOption(optionParams);

        optionParams.offerExpiryAfterHours = 24;
        optionParams.exerciseTimeInHours = 24;
        // TODO: check premium price
    }

    //  test createOption with payable
    function test_createOptionPayable() public {
        console2.log(token.balanceOf(address(alice)));
        optionSetup();
        console2.log(token.balanceOf(address(alice)));
        //console2.log(options.totalOptions);
    }

    /*//////////////////////////////////////////////////////////////
                            TEST BUY OPTION
    //////////////////////////////////////////////////////////////*/

    // test buyOption function with invalid params
    function test_buyOption() public {
        vm.expectRevert("INVALID ADDRESS");
        vm.prank(address(0x0));
        options.buyOption(0);

        vm.expectRevert("OPTION NOT FOUND");
        vm.prank(alice);
        options.buyOption(0);

        optionSetup();

        vm.expectRevert("OFFER EXPIRED");
        vm.warp(1620000000 + 24 hours);
        vm.prank(bob);
        options.buyOption(1);

        // TODO: test transfer premium to creator
        vm.warp(1620000000 - 10 hours);
        vm.prank(alice);
        options.buyOption(1);
        vm.expectRevert("ALREADY BOUGHT");
        vm.prank(bob);
        options.buyOption(1);
    }
}
