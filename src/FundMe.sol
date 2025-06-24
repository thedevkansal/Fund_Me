// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;

    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5e18;
    AggregatorV3Interface private s_priceFeed;

    // now when we deploy the contract, we can pass the price feed address
    // to the constructor, so we don't have to hardcode it in the contract.
    constructor(address priceFeed) {
        i_owner = msg.sender; // msg.sender is the address that deploys the contract
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    // Add funds to the contract
    // Record the amount funded by the sender in the mapping s_addressToAmountFunded
    // If the sender is not already in the s_funders array, add them to the array
    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");

        if (s_addressToAmountFunded[msg.sender] == 0) {
            s_funders.push(msg.sender);
        }
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    // We can use the onlyOwner modifier to restrict access to certain functions
    // only owner can call functions with onlyOwner keyword
    modifier onlyOwner() {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    //withdraw all the funds from the contract
    //Reset the s_funders array
    //Reset the mapping s_addressToAmountFunded
    function withdraw() public onlyOwner {
        uint256 funders_length = s_funders.length;
        for (uint256 funderIndex = 0; funderIndex < funders_length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        //There are 3 ways to send ETH from a contract to an address:

        // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    // We can receive funds in two ways:
    // 1. By calling the fund function directly
    // 2. By sending ETH directly to the contract address
    // The fallback and receive functions are used to handle the second case.

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    // Getter functions
    function getAddressToAmountFunded(address funder) public view returns (uint256) {
        return s_addressToAmountFunded[funder];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
