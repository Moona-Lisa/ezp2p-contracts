// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Utils} from "../src/utils/Utils.sol";

contract UtilsTest is Test {
    uint256 startTime = 1620000000;

    function test_getDurationEndTimeForDays() public {
        console2.log(block.timestamp);
        uint256 endTime = Utils.getDurationEndTimeForDays(startTime, 4);
        assertEq(endTime, 1620345600);
    }

    function test_getDurationEndTimeForHours() public {
        uint256 offerTime = Utils.getDurationEndTimeForHours(startTime, 48);
        assertEq(offerTime, 1620172800);
    }

    function test_getDurationStartTimeForHours() public {
        uint256 endTime = Utils.getDurationEndTimeForDays(startTime, 4);
        uint256 exerciceTime = Utils.getDurationStartTimeForHours(endTime, 60);
        assertEq(exerciceTime, 1620129600);
    }

    function test_substring() public {
        string memory memo = "test123";
        string memory result = Utils.substring(memo, 0, 4);
        assertEq(result, "test");
    }

    function test_st2num() public {
        string memory numString = "1234";
        uint256 result = Utils.str2num(numString);
        assertEq(result, 1234);
    }

    function test_st2addr() public {
        string memory addrString = "0x0d787a4a1548f673ed375445535a6c7A1EE56180";
        address result = Utils.str2addr(addrString);
        assertEq(result, address(0x0d787a4a1548f673ed375445535a6c7A1EE56180));
    }
}
