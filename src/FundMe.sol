// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

event FUNDME__FUNDED(address indexed from, uint256 indexed value);

error FUNDME__UNAUTHORIZED();
error FUNDME__WITHDRAWAL_FAILED();

contract FundMe {
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FUNDME__UNAUTHORIZED();
        _;
    }

    mapping(address => uint256) public s_addressToAmountFunded;
    address[] public s_funders;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
        emit FUNDME__FUNDED(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        uint256 len = s_funders.length;
        for (uint256 funderIndex; funderIndex < len; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        (bool success,) = payable(msg.sender).call{value: address(this).balance}("");
        if (!success) revert FUNDME__WITHDRAWAL_FAILED();
    }

    function getFunder(uint256 _index) public view returns (address) {
        return s_funders[_index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}
