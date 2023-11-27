// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IRouterClient} from "chainlinkccip/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "chainlinkccip/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IERC20} from "chainlinkccip/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.0/token/ERC20/IERC20.sol";
import {Utils} from "../utils/Utils.sol";

/// @title - A simple messenger contract for transferring/receiving tokens and data across chains.
contract CCIPSend {
    // Custom errors to provide more descriptive revert messages.
    error NotEnoughBalance(uint256 currentBalance, uint256 calculatedFees); // Used to make sure contract has enough balance to cover the fees.
    error DestinationChainNotAllowed(uint64 destinationChainSelector); // Used when the destination chain has not been allowlisted by the contract owner.

    // Event emitted when a message is sent to another chain.
    event MessageSent(
        bytes32 indexed messageId, // The unique ID of the CCIP message.
        uint64 indexed destinationChainSelector, // The chain selector of the destination chain.
        address receiver, // The address of the receiver on the destination chain.
        string text, // The text being sent.
        address token, // The token address that was transferred.
        uint256 tokenAmount, // The token amount that was transferred.
        address feeToken, // the token address used to pay CCIP fees.
        uint256 fees // The fees paid for sending the message.
    );

    // Mapping to keep track of allowlisted destination chains.
    mapping(uint64 => bool) public allowlistedDestinationChains;

    IERC20 private s_linkToken;
    IRouterClient private s_router;

    /// @notice Constructor initializes the contract with the router address.
    /// @param _router The address of the router contract.
    /// @param _link The address of the link contract.
    constructor(address _router, address _link) {
        s_router = IRouterClient(_router);
        s_linkToken = IERC20(_link);

        // Allowlist the Fuji testnet chain
        allowlistedDestinationChains[14767482510784806043] = true;
    }

    /// @dev Modifier that checks if the chain with the given destinationChainSelector is allowlisted.
    /// @param _destinationChainSelector The selector of the destination chain.
    modifier onlyAllowlistedDestinationChain(uint64 _destinationChainSelector) {
        if (!allowlistedDestinationChains[_destinationChainSelector])
            revert DestinationChainNotAllowed(_destinationChainSelector);
        _;
    }

    /// @notice Sends data and transfer tokens to receiver on the destination chain.
    /// @notice Pay for fees in LINK.
    /// @dev Assumes your contract has sufficient LINK to pay for CCIP fees.
    /// @param _destinationChainSelector The identifier (aka selector) for the destination blockchain.
    /// @param _receiver The address of the recipient on the destination blockchain.
    /// @param _optionId The id of the option.
    /// @param _token token address.
    /// @param _amount token amount.
    /// @return messageId The ID of the CCIP message that was sent.
    function buyOptionPayLINK(
        uint64 _destinationChainSelector,
        address _receiver,
        string calldata _optionId,
        address _token,
        uint256 _amount
    )
        external
        onlyAllowlistedDestinationChain(_destinationChainSelector)
        returns (bytes32 messageId)
    {
        string memory _text = string.concat(
            Utils.addr2str(msg.sender),
            _optionId
        );
        // Create an EVM2AnyMessage struct in memory with necessary information for sending a cross-chain message
        // address(linkToken) means fees are paid in LINK
        Client.EVM2AnyMessage memory evm2AnyMessage = _buildCCIPMessage(
            _receiver,
            _text,
            _token,
            _amount,
            address(s_linkToken)
        );

        // Get the fee required to send the CCIP message
        uint256 fees = s_router.getFee(
            _destinationChainSelector,
            evm2AnyMessage
        );

        if (fees > s_linkToken.balanceOf(address(this)))
            revert NotEnoughBalance(s_linkToken.balanceOf(address(this)), fees);

        require(
            IERC20(_token).allowance(msg.sender, address(this)) >= fees,
            "INSUFFICIENT TOKEN ALLOWANCE"
        );
        require(
            IERC20(_token).transferFrom(msg.sender, address(this), _amount),
            "AMOUNT TRANSFER FAILED"
        );
        // approve the Router to transfer LINK tokens on contract's behalf. It will spend the fees in LINK
        s_linkToken.approve(address(s_router), fees);

        // approve the Router to spend tokens on contract's behalf. It will spend the amount of the given token
        IERC20(_token).approve(address(s_router), _amount);

        // Send the message through the router and store the returned message ID
        messageId = s_router.ccipSend(
            _destinationChainSelector,
            evm2AnyMessage
        );

        // Emit an event with message details
        emit MessageSent(
            messageId,
            _destinationChainSelector,
            _receiver,
            _text,
            _token,
            _amount,
            address(s_linkToken),
            fees
        );

        // Return the message ID
        return messageId;
    }

    /// @notice Construct a CCIP message.
    /// @dev This function will create an EVM2AnyMessage struct with all the necessary information for programmable tokens transfer.
    /// @param _receiver The address of the receiver.
    /// @param _text The string data to be sent.
    /// @param _token The token to be transferred.
    /// @param _amount The amount of the token to be transferred.
    /// @param _feeTokenAddress The address of the token used for fees. Set address(0) for native gas.
    /// @return Client.EVM2AnyMessage Returns an EVM2AnyMessage struct which contains information for sending a CCIP message.
    function _buildCCIPMessage(
        address _receiver,
        string memory _text,
        address _token,
        uint256 _amount,
        address _feeTokenAddress
    ) internal pure returns (Client.EVM2AnyMessage memory) {
        // Set the token amounts
        Client.EVMTokenAmount[]
            memory tokenAmounts = new Client.EVMTokenAmount[](1);
        tokenAmounts[0] = Client.EVMTokenAmount({
            token: _token,
            amount: _amount
        });
        // Create an EVM2AnyMessage struct in memory with necessary information for sending a cross-chain message
        return
            Client.EVM2AnyMessage({
                receiver: abi.encode(_receiver), // ABI-encoded receiver address
                data: abi.encode(_text), // ABI-encoded string
                tokenAmounts: tokenAmounts, // The amount and type of token being transferred
                extraArgs: Client._argsToBytes(
                    // Additional arguments, setting gas limit and non-strict sequencing mode
                    Client.EVMExtraArgsV1({gasLimit: 200_000, strict: false})
                ),
                // Set the feeToken to a feeTokenAddress, indicating specific asset will be used for fees
                feeToken: _feeTokenAddress
            });
    }
}
