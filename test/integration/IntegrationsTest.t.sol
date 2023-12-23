// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/FundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interactions.s.sol";

contract IntegrationsTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 public constant VALUE = 69e18;
    uint256 public constant INITIAL_BALANCE = 100e18;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, INITIAL_BALANCE);
    }

    function testUserCanFundThanOwnerCanWithdraw() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        assert(address(fundMe).balance != 0); // to make sure fundFundMe() works, the test may pass even if we're not sure withdrawFundMe() works

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
