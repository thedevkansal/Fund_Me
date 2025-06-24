// Provides price feed configuration across networks
// Uses Chainlink on live networks and deploys mocks locally (e.g., Anvil)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DeployMocks} from "./DeployMocks.s.sol";

contract HelperConfig is Script {

    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
    
    // Struct to hold network-specific configurations, such as price feed addresses
    struct NetworkConfig {
        address priceFeed;
    }

    // Store the active network configuration
    NetworkConfig public activeNetworkConfig; 
        
    constructor() {
        if (block.chainid == ETH_SEPOLIA_CHAIN_ID) { // Sepolia
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == LOCAL_CHAIN_ID) { // Anvil
            activeNetworkConfig = getAnvilEthConfig();
        } else {
            revert("No active network config found");
        }
        // Extendable: Add support for other networks here (Mainnet, Polygon, etc.)
    }

    function getSepoliaEthConfig () public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // Sepolia ETH/USD price feed address
        });
        return sepoliaConfig;
    }

    function getAnvilEthConfig () public returns (NetworkConfig memory) {

        // To prevent redeploying a mock price feed if it's already deployed.
        if (block.chainid == LOCAL_CHAIN_ID && activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        // Deploy the mock using the DeployMocks script
        DeployMocks deployMock = new DeployMocks();
        address mockPriceFeed = deployMock.run();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        activeNetworkConfig = anvilConfig; // Update the active network config
        return anvilConfig ;
    }

    function getPriceFeed() public view returns (address) {
    return activeNetworkConfig.priceFeed;
    }

    // Function to get the configuration based on the chain ID manually
    function getConfigByChainId(uint256 chainId) public returns (NetworkConfig memory) {
        if (chainId == ETH_SEPOLIA_CHAIN_ID) return getSepoliaEthConfig();
        if (chainId == LOCAL_CHAIN_ID) return getAnvilEthConfig();
        revert("Chain ID not supported");
    }
}
