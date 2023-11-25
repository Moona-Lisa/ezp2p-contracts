// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library Utils {
    function getDurationEndTimeForDays(
        uint256 startTime,
        uint256 totalDurationInDays
    ) internal pure returns (uint256) {
        return (startTime + (totalDurationInDays * 86400));
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

    function substring(
        string memory str,
        uint startIndex,
        uint endIndex
    ) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }

    function str2num(string memory numString) internal pure returns (uint256) {
        uint256 val = 0;
        bytes memory stringBytes = bytes(numString);
        for (uint i = 0; i < stringBytes.length; i++) {
            uint exp = stringBytes.length - i;
            bytes1 ival = stringBytes[i];
            uint8 uval = uint8(ival);
            uint jval = uval - uint(0x30);

            val += (uint(jval) * (10 ** (exp - 1)));
        }
        return val;
    }

    function str2addr(string memory str) internal pure returns (address) {
        require(
            bytes(str).length == 42,
            "String length must be 42 with '0x' prefix"
        );
        bytes memory temp = bytes(str);
        uint160 num = 0;
        uint160 val = 0;

        for (uint160 i = 2; i < 42; i++) {
            uint160 c = uint160(uint8(temp[i]));

            if ((c >= 48) && (c <= 57)) {
                val = c - 48; // numbers
            } else if ((c >= 65) && (c <= 70)) {
                val = c - 55; // A-F
            } else if ((c >= 97) && (c <= 102)) {
                val = c - 87; // a-f
            } else {
                revert("Invalid character in address");
            }

            assembly {
                num := add(mul(num, 16), val)
            }
        }

        return address(num);
    }

    function addr2str(address _addr) internal pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(_addr)));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(42);
        str[0] = "0";
        str[1] = "x";

        for (uint256 i = 0; i < 20; i++) {
            str[2 + i * 2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }

        return string(str);
    }
}
