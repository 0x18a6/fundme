// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function test_MinUsdIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function test_OwnerIsMsgSender() public {
        console.log("i_owner:", fundMe.i_owner());
        assertEq(fundMe.i_owner(), address(this)); /// @dev compare to the address of the test contract because technically it's the msg.sender of fundMe
    }

    // forge test --match-test test_versionIsAccurate --fork-url $SEPOLIA_URL
    function test_versionIsAccurate() public {
        assertEq(fundMe.getVersion(), 4);
    }
}
