// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Utils} from "../src/utils/Utils.sol";

contract CCIPSendTest is Test {
    function setUp() public {}

    function test_CCIP() public {
        vm.prank(address(this));
        string memory _optionId = "61";
        string memory _text = string.concat(
            Utils.addr2str(msg.sender),
            _optionId
        );

        console2.log(_text);
    }
}
