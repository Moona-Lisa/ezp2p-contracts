// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {MockOptions} from "./MockOptions.sol";
import {DataTypes} from "../src/utils/DataTypes.sol";
import {ERC20} from "../src/lib/ERC20.sol";
import {MockERC20} from "./MockERC20.sol";
import {Utils} from "../src/utils/Utils.sol";

contract TokensTest is Test {
    MockOptions public options;
    MockERC20 public token;

    // address public immutable owner;
    address constant alice = address(0xA11CE);
    address constant bob = address(0xB0B);

    DataTypes.CreateTokenParams public testTokenParams1;
    DataTypes.CreateTokenParams public testTokenParams2;

    address[2] updaters;

    function setUp() public {
        options = new MockOptions();
        token = new MockERC20("Token", "TKN", 18);

        testTokenParams1 = DataTypes.CreateTokenParams(
            "Token",
            address(0x1351),
            true,
            "test",
            18,
            address(0x1351),
            false
        );
        testTokenParams2 = DataTypes.CreateTokenParams(
            "Token",
            address(token),
            true,
            "TKN",
            18,
            address(0x1351),
            false
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
        options.updateTokensPrice();
    }

    // test receive function response
    function test_receive() public {
        DataTypes.CreateTokenParams memory testTokenLink = DataTypes
            .CreateTokenParams(
                "chainlink",
                address(0x326C977E6efc84E512bB9C30f76E30c160eD06FB),
                true,
                "LINK",
                18,
                address(0x1351),
                false
            );

        options.addToken(testTokenLink);

        string
            memory str = '[{"token":"0x326C977E6efc84E512bB9C30f76E30c160eD06FB","volatility":0.7115863873063887}]';

        bytes memory b = bytes(str);
        options.fulfillRequestMock(b);
        options.updateTokensVolatilityMock();
    }
}
