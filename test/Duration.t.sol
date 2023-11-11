// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Duration} from "../src/utils/Duration.sol";

contract DurationTest is Test {
    uint256 startTime = 1620000000;

    function test_getDurationEndTimeForDays() public {
        console2.log(block.timestamp);
        uint256 endTime = Duration.getDurationEndTimeForDays(startTime, 4);
        assertEq(endTime, 1620345600);
    }

    function test_getDurationEndTimeForHours() public {
        uint256 offerTime = Duration.getDurationEndTimeForHours(startTime, 48);
        assertEq(offerTime, 1620172800);
    }

    function test_getDurationStartTimeForHours() public {
        uint256 endTime = Duration.getDurationEndTimeForDays(startTime, 4);
        uint256 exerciceTime = Duration.getDurationStartTimeForHours(
            endTime,
            60
        );
        assertEq(exerciceTime, 1620129600);
    }
}
