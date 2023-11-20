// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/SignedWadMath.sol";
import {FixedPointMathLib} from "../lib/FixedPointMathLib.sol";
import {BlackScholesMertonStorage} from "../storage/BlackScholesMertonStorage.sol";

contract BlackScholesMerton is BlackScholesMertonStorage {
    /*////////////////////////////////////////////////////////////////////////////////
        CUMULATIVE DISTRIBUTION FUNCTION (CDF) FOR A STANDARD NORMAL DISTRIBUTION
    ////////////////////////////////////////////////////////////////////////////////*/
    /**
     * @dev The function approximates the area under the curve of a standard normal distribution
     * It uses values that are pre-calculated to ensure the approximation is as accurate as possible
     */
    function cumulativeDistributionFunction(
        int256 x
    ) internal pure returns (int256) {
        int256 t = wadDiv(
            ONE,
            (ONE + wadMul(P, wadMul(int256(x < 0 ? -x : x), ONE)))
        );
        int256 poly = wadMul(
            (wadMul((wadMul((wadMul(B5, t) + B4), t) + B3), t) + B2),
            t
        ) + B1;
        int256 result = wadMul(
            wadMul(C, wadExp(wadDiv(wadMul(-x, x), TWO))),
            wadMul(t, poly)
        );
        return x >= 0 ? ONE - result : result;
    }

    /*////////////////////////////////////////////////////////////////////////////////
                            BLACK-SCHOLES-MERTON FORMULA
    ////////////////////////////////////////////////////////////////////////////////*/
    function blackScholesMertonOptionPrice(
        bool isCall,
        int256 S,
        int256 K,
        int256 T,
        int256 r,
        int256 v
    ) public pure returns (int256) {
        // S - current price for 1 unit
        // K - strike price for 1 unit
        // T - time to maturity
        // r - risk free premium rate
        // v - annualized volatility

        int256 sqrtT = int256(FixedPointMathLib.sqrt(uint256(T))) * 1000000000;
        int256 d1 = wadLn(wadDiv(S, K)) +
            wadDiv(
                wadMul((r + wadDiv(wadMul(v, v), TWO)), T),
                wadMul(v, sqrtT)
            );
        int256 d2 = d1 - wadMul(v, sqrtT);
        int256 exp = wadExp(wadMul(-r, T));

        if (isCall) {
            return
                wadMul(S, cumulativeDistributionFunction(d1)) -
                wadMul(wadMul(K, exp), cumulativeDistributionFunction(d2));
        } else {
            return
                wadMul(wadMul(K, exp), cumulativeDistributionFunction(-d2)) -
                wadMul(S, cumulativeDistributionFunction(-d1));
        }
    }
}
