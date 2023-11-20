// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {BSM} from "../src/utils/BSM.sol";
import {SD59x18, sd} from "prb/src/SD59x18.sol";

contract BSMTest is Test {
    BSM public bsm;
    SD59x18 public S;
    SD59x18 public K;
    SD59x18 public T;
    SD59x18 public r;
    SD59x18 public v;
    bool public isCall;

    function setUp() public {
        bsm = new BSM();
        S = sd(0e18);
        K = sd(0e18);
        T = sd(0e18);
        r = sd(0.01e18);
        v = sd(0e18);
        isCall = true;
    }

    function test_BSMOptionPrice() public {
        vm.expectRevert("CURRENT PRICE MUST BE POSITIVE");
        bsm.BSMOptionPrice(isCall, S, K, T, r, v);

        S = sd(37000e18);
        vm.expectRevert("STRIKE PRICE MUST BE POSITIVE");
        bsm.BSMOptionPrice(isCall, S, K, T, r, v);

        K = sd(40000e18);
        vm.expectRevert("TIME MUST BE >= 0.00273");
        bsm.BSMOptionPrice(isCall, S, K, T, r, v);

        T = sd(0.00274e18);
        vm.expectRevert("VOLATILITY MUST BE > 0");
        bsm.BSMOptionPrice(isCall, S, K, T, r, v);

        v = sd(1e18);
        vm.expectRevert("VOLATILITY MUST BE < 1");
        bsm.BSMOptionPrice(isCall, S, K, T, r, v);

        v = sd(0.5e18);
        bsm.BSMOptionPrice(isCall, S, K, T, r, v);
    }
}
