// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // not a real tx, gas good
        HelperConfig helperConfig = new HelperConfig();
        FundMe fundMe;

        address ethPriceFeed = helperConfig.activeConfig();

        // real tx, gas bad
        vm.startBroadcast();
        fundMe = new FundMe(ethPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
