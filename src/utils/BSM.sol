// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {BSMStorage} from "src/storage/BSMStorage.sol";
import {SD59x18, sd, UNIT, div, mul, exp, sqrt, ln} from "prb/src/SD59x18.sol";
import {IBSM} from "../interfaces/IBSM.sol";

/**
 * @title BSM
 * @author MoonaLisa
 *
 * @notice This is the Black-Scholes-Merton formula for pricing European call and put options.
 */
contract BSM is BSMStorage, IBSM {
    /*//////////////////////////////////////////////////////////////
                              PUBLIC VIEW
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IBSM
    function BSMOptionPrice(
        bool isCall,
        SD59x18 S,
        SD59x18 K,
        SD59x18 T,
        SD59x18 r,
        SD59x18 v
    ) public view returns (SD59x18) {
        require(S.unwrap() > 0, "CURRENT PRICE MUST BE POSITIVE");
        require(K.unwrap() > 0, "STRIKE PRICE MUST BE POSITIVE");
        require(T > sd(0.00273e18), "TIME MUST BE >= 0.00273");
        require(v > sd(0e18), "VOLATILITY MUST BE > 0");
        require(v < sd(1e18), "VOLATILITY MUST BE < 1");

        SD59x18 sqrtT = sqrt(T);
        SD59x18 d1 = div(
            ln(div(S, K)) + mul((r + div(mul(v, v), sd(2e18))), T),
            mul(v, sqrtT)
        );
        SD59x18 d2 = d1 - mul(v, sqrtT);
        SD59x18 expValue = exp(mul(-r, T));

        if (isCall) {
            return
                mul(S, CDF(d1.unwrap())) -
                mul(mul(K, expValue), CDF(d2.unwrap()));
        } else {
            return
                mul(mul(K, expValue), CDF(-d2.unwrap())) -
                mul(S, CDF(-d1.unwrap()));
        }
    }

    /// @inheritdoc IBSM
    function CDF(int256 x) public view returns (SD59x18) {
        SD59x18 xAbs = sd(x < 0 ? -x : x);
        SD59x18 t = div(UNIT, (UNIT + mul(P, xAbs)));
        SD59x18 expValue = exp(div(mul(sd(-x), sd(x)), sd(2e18)));
        SD59x18 poly = mul(mul(mul((mul(B5, t) + B4), t) + B3, t) + B2, t) + B1;
        SD59x18 result = mul(mul(mul(C, expValue), t), poly);
        return x >= 0 ? (UNIT - result) : result;
    }
}
