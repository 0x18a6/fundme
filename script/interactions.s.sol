// SPDX-License-Identifier: MIT

// Fund
// Withdraw

pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "foundry-devops/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 public constant VALUE = 69e18;

    function fundFundMe(address _mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(_mostRecentlyDeployed)).fund{value: VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe contract with %s", VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        // fundFundMe(mostRecentlyDeployed);
    }
}

contract WithdrawFundMe is Script {
    uint256 public constant VALUE = 69e18;

    function withdrawFundMe(address _mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(_mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Withdrew from FundMe contract");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentlyDeployed);
    }
}
