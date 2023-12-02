// SPDX-License-Identifier: MIT

// 1. deploy mocks when where're on a local anvil chain
// 2. keep track of contract address accross different chains

pragma solidity ^0.8.23;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // if we're on a local anvil chain, deploy mocks
    // otherwhise, get the existing address from the live network
    struct NetworkConfig {
        address priceFeed;
    }

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    NetworkConfig public activeConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            activeConfig = getMainnetConfig();
        } else {
            activeConfig = getAnvilConfig();
        }
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory config = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return config;
    }

    function getMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory config = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return config;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        // deploy the mock
        // return the mock address

        vm.startBroadcast();
        /// @dev mocking a contract essentially means creating a second version of that contract which behaves very similar to the original one, but in a way that can be easily controlled by the developer
        MockV3Aggregator mock = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory config = NetworkConfig({priceFeed: address(mock)});
        return config;
    }
}
