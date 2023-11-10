// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library Duration {
    function getDurationEndTimeForDays(
        uint256 startTime,
        uint256 nbOfDays
    ) internal pure returns (uint256) {
        return (startTime + (nbOfDays * 86400));
    }

    function getDurationEndTimeForHours(
        uint256 startTime,
        uint256 nbOfHours
    ) internal pure returns (uint256) {
        return (startTime + (nbOfHours * 3600));
    }

    function getDurationStartTimeForHours(
        uint256 endTime,
        uint256 nbOfHours
    ) internal pure returns (uint256) {
        return (endTime - (nbOfHours * 3600));
    }
}
