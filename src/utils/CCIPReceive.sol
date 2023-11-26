// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IRouterClient} from "chainlinkccip/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Auth} from "../lib/Auth.sol";
import {CCIPReceiver} from "chainlinkccip/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {Client} from "chainlinkccip/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IOptions} from "../interfaces/IOptions.sol";
import {Utils} from "../utils/Utils.sol";
import {ERC20} from "../lib/ERC20.sol";

contract CCIPReceive is CCIPReceiver, Auth {
    IOptions options;
    // Custom errors to provide more descriptive revert messages.
    error SourceChainNotAllowed(uint64 sourceChainSelector); // Used when the source chain has not been allowlisted by the contract owner.

    // Mapping to keep track of allowlisted source chains.
    mapping(uint64 => bool) public allowlistedSourceChains;

    /// @notice Constructor initializes the contract with the router address.
    // hardcode the router address for the Fuji testnet router
    constructor(
        address optionsAddr
    ) CCIPReceiver(0x554472a2720E5E7D5D3C817529aBA05EEd5F82D8) {
        options = IOptions(optionsAddr);
        // Allowlist the Mumbai testnet chain
        allowlistedSourceChains[12532609583862916517] = true;
        // Allowlist the Sepolia testnet chain
        allowlistedSourceChains[16015286601757825753] = true;
    }

    /// @dev Modifier that checks if the chain with the given sourceChainSelector is allowlisted and if the sender is allowlisted.
    /// @param _sourceChainSelector The selector of the destination chain.
    modifier onlyAllowlisted(uint64 _sourceChainSelector) {
        if (!allowlistedSourceChains[_sourceChainSelector])
            revert SourceChainNotAllowed(_sourceChainSelector);
        _;
    }

    function _ccipReceive(
        Client.Any2EVMMessage memory any2EvmMessage
    ) internal override onlyAllowlisted(any2EvmMessage.sourceChainSelector) {
        string memory decoded = abi.decode(any2EvmMessage.data, (string));
        string memory msgAddr = Utils.substring(decoded, 0, 42);

        uint256 len = bytes(decoded).length;
        require(len > 42, "INVALID DATA");
        uint256 optionId = Utils.str2num(Utils.substring(decoded, 42, len));

        address sender = Utils.str2addr(msgAddr);

        address tokenaddr = any2EvmMessage.destTokenAmounts[0].token;
        uint256 amt = any2EvmMessage.destTokenAmounts[0].amount;

        require(
            tokenaddr == address(0xD21341536c5cF5EB1bcb58f6723cE26e8D8E90e4),
            "ASSET NOT COMPATIBLE"
        );

        require(
            ERC20(address(0xD21341536c5cF5EB1bcb58f6723cE26e8D8E90e4)).transfer(
                address(options),
                amt
            ),
            "ASSET TRANSFER FAILED"
        );

        options.buyOptionCCIP(optionId, sender, tokenaddr, amt);
    }
}
