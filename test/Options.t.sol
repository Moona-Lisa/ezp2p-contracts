// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Options} from "../src/core/Options.sol";
import {DataTypes} from "../src/utils/DataTypes.sol";
import {ERC20} from "../src/lib/ERC20.sol";
import {MockERC20} from "./MockERC20.sol";

contract OptionsTest is Test {
    Options public options;
    MockERC20 public token;

    // address public immutable owner;
    address constant alice = address(0xA11CE);

    DataTypes.CreateOptionParams public params;

    function setUp() public {
        options = new Options();
        token = new MockERC20("Token", "TKN", 18);
        params = DataTypes.CreateOptionParams(
            "test",
            2,
            500,
            0,
            address(0x001),
            address(0x002),
            0,
            0,
            true
        );
    }

    /*//////////////////////////////////////////////////////////////
                        TEST ADD/ALLOW TOKEN
    //////////////////////////////////////////////////////////////*/

    // test addToken function as not owner
    function test_addTokenNotOwner() public {
        vm.expectRevert("UNAUTHORIZED OWNER");
        vm.prank(alice);
        options.addToken("test", address(0x1351), true, "test", 18);
    }

    // test addToken function as owner
    function test_addTokenAsOwner() public {
        options.addToken("test", address(0x1351), true, "test", 18);
    }

    // test allowToken function as not owner
    function test_allowTokenNotOwner() public {
        vm.expectRevert("UNAUTHORIZED OWNER");
        vm.prank(alice);
        options.allowToken(address(0x1351), true);
    }

    // test allowToken not exist
    function test_allowTokenNotExistAsOwner() public {
        vm.expectRevert("TOKEN NOT FOUND");
        options.allowToken(address(0x1351), true);
    }

    // test allowToken function as owner
    function test_allowTokenAsOwner() public {
        options.addToken("test", address(0x1351), true, "test", 18);
        options.allowToken(address(0x1351), true);
    }

    /*//////////////////////////////////////////////////////////////
                        TEST CREATE OPTION
    //////////////////////////////////////////////////////////////*/

    // test createOption function with invalid params
    function test_createOptionInvalid() public {
        vm.expectRevert("ASSET1 NOT FOUND");
        vm.prank(alice);
        options.createOption(params);

        options.addToken("test", address(0x001), true, "test", 18);
        vm.expectRevert("ASSET2 NOT FOUND");
        vm.prank(alice);
        options.createOption(params);

        options.addToken("test2", address(0x002), false, "test", 18);
        vm.expectRevert("ASSET2 NOT ALLOWED");
        vm.prank(alice);
        options.createOption(params);

        options.allowToken(address(0x002), true);
        vm.expectRevert("AMOUNT MUST BE POSITIVE");
        vm.prank(alice);
        options.createOption(params);

        params.amount = 5000;
        vm.expectRevert("DURATION MUST BE MORE THAN 3 DAYS");
        vm.prank(alice);
        options.createOption(params);

        params.nbOfDays = 4;
        vm.expectRevert("OFFER EXPIRY TIME MUST BE POSITIVE");
        vm.prank(alice);
        options.createOption(params);

        params.offerExpiryAfterHours = 48;
        vm.expectRevert("EXERCISE TIME MUST BE POSITIVE");
        vm.prank(alice);
        options.createOption(params);

        params.exerciseTimeInHours = 60;
        vm.warp(1620000000);
        vm.expectRevert("OFFER EXPIRY TIME MUST BE BEFORE EXERCISE TIME");
        vm.prank(alice);
        options.createOption(params);

        params.offerExpiryAfterHours = 24;
        params.exerciseTimeInHours = 24;
    }

    //  test createOption with payable
    function test_createOptionPayable() public {
        params.amount = 5000;
        params.nbOfDays = 4;
        params.offerExpiryAfterHours = 24;
        params.exerciseTimeInHours = 24;
        params.asset1 = address(token);

        options.addToken("Token", address(token), true, "TKN", 18);
        options.addToken("test", address(0x002), true, "test", 18);
        vm.warp(1620000000);

        token.mint(address(alice), 1e18);
        console2.log(token.balanceOf(address(alice)));
        vm.prank(alice);
        token.approve(address(options), 5000);
        vm.prank(alice);
        //console2.log(options.totalOptions);
        options.createOption(params);
        console2.log(token.balanceOf(address(alice)));
        //console2.log(options.totalOptions);
    }
}
