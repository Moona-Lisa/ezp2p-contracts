// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Options} from "../src/core/Options.sol";
import {DataTypes} from "../src/utils/DataTypes.sol";
import {ERC20} from "../src/lib/ERC20.sol";
import {MockERC20} from "./MockERC20.sol";

contract TokensTest is Test {
    Options public options;
    MockERC20 public token;

    // address public immutable owner;
    address constant alice = address(0xA11CE);
    address constant bob = address(0xB0B);

    DataTypes.CreateTokenParams public testTokenParams1;
    DataTypes.CreateTokenParams public testTokenParams2;

    address[2] updaters;

    function setUp() public {
        options = new Options();
        token = new MockERC20("Token", "TKN", 18);

        testTokenParams1 = DataTypes.CreateTokenParams(
            "Token",
            address(0x1351),
            true,
            "test",
            18
        );
        testTokenParams2 = DataTypes.CreateTokenParams(
            "Token",
            address(token),
            true,
            "TKN",
            18
        );

        updaters = [address(alice), address(bob)];
    }

    /*//////////////////////////////////////////////////////////////
                        TEST ADD/ALLOW TOKEN
    //////////////////////////////////////////////////////////////*/

    // test addToken function as not owner
    function test_addTokenNotOwner() public {
        vm.expectRevert("UNAUTHORIZED OWNER");
        vm.prank(alice);
        options.addToken(testTokenParams1);
    }

    // test addToken function as owner
    function test_addTokenAsOwner() public {
        options.addToken(testTokenParams1);
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
        options.addToken(testTokenParams1);
        options.allowToken(address(0x1351), true);
    }

    /*//////////////////////////////////////////////////////////////
                        TEST UPDATE TOKEN
    //////////////////////////////////////////////////////////////*/

    // test updateTokenPrice function
    function test_updateTokenPrice() public {
        options.addToken(testTokenParams1);
        options.addToken(testTokenParams2);

        vm.expectRevert("UNAUTHORIZED UPDATER");
        vm.prank(alice);
        options.updateTokenPrice(address(0x1351), 100);

        options.setUpdater(updaters);
        vm.prank(alice);
        options.updateTokenPrice(address(0x1351), 100);

        vm.prank(bob);
        options.updateTokenVolatility(address(0x1351), 100);
    }
}
