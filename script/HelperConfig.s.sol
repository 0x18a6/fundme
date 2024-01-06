// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script} from "forge-std/Script.sol";
import {MockFundMe} from "../test/mocks/MockFundMe.sol";

contract HelperConfig is Script {
    // 1. deploy mocks when where're on a local anvil chain
    // 2. keep track of contract address accross different chains

    struct NetworkConfig {
        address fundMe;
    }

    NetworkConfig public activeConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeConfig = getSepoliaConfig();
        } else {
            activeConfig = getAnvilConfig();
        }
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory config = NetworkConfig({fundMe: 0xD0bC6B019c3398F21f20bd8EE5d41Df913A10Ea6});
        return config;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        // deploy the mock
        // return the mock address

        if (activeConfig.fundMe != address(0)) {
            return activeConfig;
        }

        vm.startBroadcast();
        MockFundMe mock = new MockFundMe();
        vm.stopBroadcast();

        NetworkConfig memory config = NetworkConfig({fundMe: address(mock)});
        return config;
    }
}
