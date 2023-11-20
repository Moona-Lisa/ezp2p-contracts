// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Events} from "../utils/Events.sol";

abstract contract Auth {
    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/
    address public owner;
    address[2] public updater;

    /*//////////////////////////////////////////////////////////////
                                 CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {
        owner = msg.sender;
    }

    /*//////////////////////////////////////////////////////////////
                                  MODIFIER
    //////////////////////////////////////////////////////////////*/

    modifier onlyOwner() virtual {
        require(msg.sender == owner, "UNAUTHORIZED OWNER");
        _;
    }

    modifier onlyUpdater() virtual {
        require(
            msg.sender == owner ||
                msg.sender == updater[0] ||
                msg.sender == updater[1],
            "UNAUTHORIZED UPDATER"
        );
        _;
    }

    /*//////////////////////////////////////////////////////////////
                                  PUBLIC
    //////////////////////////////////////////////////////////////*/

    function setUpdater(address[2] memory _updater) public onlyOwner {
        updater = _updater;

        emit Events.SetUpdaters(_updater);
    }
}
