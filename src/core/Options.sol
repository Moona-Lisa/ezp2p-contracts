// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Owned} from "../utils/Owned.sol";
import {OptionsStorage} from "../storage/OptionsStorage.sol";

contract Options is Owned, OptionsStorage {}
