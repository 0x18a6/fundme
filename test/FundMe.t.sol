// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/FundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();

        vm.deal(USER, 100 ether);
    }

    function test_MinUsdIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 2e18);
    }

    // FIXME: this test is not reverting on my machine
    function test_fundFailsWithoutEnoughETH() public payable {
        vm.expectRevert();
        fundMe.fund{value: 2e18}();
    }

    // function test_fund() public {
    //     vm.prank(USER);
    //     vm.expectRevert();
    //     fundMe.fund{value: 2e18}();
    // }

    function test_fundersUpdated() public payable {
        fundMe.fund{value: 69e18}();
        assertEq(fundMe.getFunder(0), address(this));
    }

    function test_OwnerIsMsgSender() public {
        console.log("i_owner:", fundMe.i_owner());
        assertEq(fundMe.i_owner(), msg.sender);
        /// @dev compare to the address of the test contract because technically it's the msg.sender of fundMe
    }

    // forge test --match-test test_versionIsAccurate --fork-url $SEPOLIA_URL
    function test_versionIsAccurate() public {
        assertEq(fundMe.getVersion(), 4);
    }
}
