// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {FunctionsClient} from "chainlink/contracts/src/v0.8/functions/dev/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "chainlink/contracts/src/v0.8/functions/dev/v1_0_0/libraries/FunctionsRequest.sol";
import {Auth} from "../lib/Auth.sol";
import {TokensStorage} from "../storage/TokensStorage.sol";
import {Utils} from "./Utils.sol";
import {Events} from "./Events.sol";

/**
 * @title FunctionsConsumer
 * @notice A contract that consumes requests from a Chainlink node
 * @dev This contract uses hardcoded values and should not be used in production.
 */
contract FunctionsConsumer is FunctionsClient, Auth, TokensStorage {
    using FunctionsRequest for FunctionsRequest.Request;

    // State variables to store the last request ID, response, and error
    bytes32 public s_lastRequestId;
    bytes public s_lastResponse;
    bytes public s_lastError;

    // Custom error type
    error UnexpectedRequestID(bytes32 requestId);

    // Event to log responses
    event Response(bytes32 indexed requestId, bytes response, bytes err);

    // Router address - Hardcoded for Mumbai
    address router = 0xA9d587a00A31A52Ed70D6026794a8FC5E2F5dCb0;

    // JavaScript source code
    string source =
        "const addr = args[0];"
        "const apiResponse = await Functions.makeHttpRequest({"
        "url: `https://elgzbdxzycxyhcnpglte.supabase.co/rest/v1/tokens?contract_addr=eq.${addr}&select=contract_addr,annualized_volatility`,"
        "headers: {'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVsZ3piZHh6eWN4eWhjbnBnbHRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA2NTc3NDAsImV4cCI6MjAxNjIzMzc0MH0.9Rxf8xtFL-KtIErifLJaJ99z-S6v_PnL4gnzjvInzI8'},"
        "});"
        "if (apiResponse.error) {"
        "throw Error('Request failed');"
        "}"
        "const { data } = apiResponse;"
        "let structure = data[0].contract_addr + ',' +data[0].annualized_volatility;"
        "return Functions.encodeString(structure);";

    //Callback gas limit
    uint32 gasLimit = 300000;

    // donID - Hardcoded for Mumbai
    bytes32 donID =
        0x66756e2d6176616c616e6368652d66756a692d31000000000000000000000000;

    /**
     * @notice Initializes the contract with the Chainlink router address and sets the contract owner
     */
    constructor() FunctionsClient(router) {}

    /**
     * @notice Sends an HTTP request for character information
     * @param subscriptionId The ID for the Chainlink subscription
     * @param args The arguments to pass to the HTTP request
     * @return requestId The ID of the request
     */
    function sendRequest(
        uint64 subscriptionId,
        string[] memory args
    ) public onlyOwner returns (bytes32 requestId) {
        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(source); // Initialize the request with JS code
        if (args.length > 0) req.setArgs(args); // Set the arguments for the request

        // Send the request and store the request ID
        s_lastRequestId = _sendRequest(
            req.encodeCBOR(),
            subscriptionId,
            gasLimit,
            donID
        );

        return s_lastRequestId;
    }

    /**
     * @notice Callback function for fulfilling a request
     * @param requestId The ID of the request to fulfill
     * @param response The HTTP response data
     * @param err Any errors from the Functions request
     */
    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        if (s_lastRequestId != requestId) {
            revert UnexpectedRequestID(requestId); // Check if request IDs match
        }
        // Update the contract's state variables with the response and any errors
        s_lastResponse = response;
        s_lastError = err;

        if (response.length > 0) {
            // Parse the response and update the tokensMap
            address tokenAddr = Utils.str2addr(
                Utils.substring(string(response), 0, 42)
            );

            uint256 volValue = Utils.str2num(
                Utils.substring(string(response), 43, 51)
            );

            require(
                tokensMap[tokenAddr].tokenAddress != address(0),
                "TOKEN NOT FOUND"
            );

            tokensMap[tokenAddr].annualizedVolatility = volValue;
            emit Events.TokenVolatilityUpdated(tokenAddr, volValue);
        }

        // Emit an event to log the response
        emit Response(requestId, s_lastResponse, s_lastError);
    }
}
