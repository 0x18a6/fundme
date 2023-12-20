// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/FundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 public constant VALUE = 69e18;
    uint256 public constant INITIAL_BALANCE = 100e18;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, INITIAL_BALANCE);
    }

    function test_MinUsdIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 2e18);
    }

    // FIXME: this test is not reverting on my machine
    // function test_RevertWithoutEnoughETH() public payable {
    //     vm.expectRevert();
    //     fundMe.fund{value: 2e18}();
    // }

    function test_RevertWithoutEnoughETH() public {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.fund{value: 2e18}();
    }

    function test_AddressToAmountFundedIsUpdated() public payable {
        vm.prank(USER);
        fundMe.fund{value: VALUE}();
        assertEq(fundMe.s_addressToAmountFunded(USER), VALUE);
    }

    function test_funderIsUpdated() public payable {
        vm.prank(USER);
        fundMe.fund{value: VALUE}();
        assertEq(fundMe.getFunder(0), USER);
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

    modifier funded(address _prankster) {
        vm.prank(_prankster);
        fundMe.fund{value: VALUE}();
        _;
    }

    function test_OnlyOwnerCanWithdraw() public funded(USER) {
        vm.expectRevert();
        fundMe.withdraw();
        vm.stopPrank();
    }

    function test_withdraw( /*uint256 _numberOfFunders*/ ) public funded(USER) {
        uint256 _numberOfFunders = 3;

        // arrange
        if (_numberOfFunders > 1) {
            for (uint160 i; i < _numberOfFunders; i++) {
                hoax(fundMe.getFunder(i), VALUE);
                fundMe.fund{value: VALUE}();
            }
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        console.log("startingOwnerBalance:", startingOwnerBalance);
        uint256 startingFundMeBalance = address(fundMe).balance;
        console.log("startingFundMeBalance:", startingFundMeBalance);

        // act
        // vm.startPrank(fundMe.getOwner());
        // vm.prank(fundMe.getOwner());
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        console.log("endingOwnerBalance:", endingOwnerBalance);
        uint256 endingFundMeBalance = address(fundMe).balance;
        console.log("endingFundMeBalance:", endingFundMeBalance);

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
        // vm.stopPrank();
    }
}
