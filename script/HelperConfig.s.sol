// SPDX-License-Identifier: MIT

// 1. deploy mocks when where're on a local anvil chain
// 2. keep track of contract address accross different chains

pragma solidity ^0.8.23;

import {Script} from "forge-std/Script.sol";

contract HelperConfig {
    // if we're on a local anvil chain, deploy mocks
    // otherwhise, get the existing address from the live network
    struct NetworkConfig {
        address priceFeed;
    }

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

    function getAnvilConfig() public pure returns (NetworkConfig memory) {}
}
