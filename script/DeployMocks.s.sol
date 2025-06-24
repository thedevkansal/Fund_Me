// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// DeployMocks.s.sol — Deploys mock Chainlink Price Feed on local chains like Anvil

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";

contract DeployMocks is Script {
    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_PRICE = 2000e8; // 2000 USD with 8 decimals

    function run() external returns (address) {
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        return address(mockPriceFeed);
    }
}
