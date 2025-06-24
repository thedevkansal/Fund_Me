//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {

    address constant USER = address(1); // This is a mock user address for testing purposes
    uint256 constant STARTING_BALANCE = 10 ether; // This is the starting balance for the user
    uint256 constant SEND_VALUE = 1 ether; 

    FundMe public fundMe;
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run(); // This will deploy the FundMe contract exactly as it would in the script
        vm.deal(USER, STARTING_BALANCE); // This gives the USER address a starting balance of 10 ether
    } 
    
    //To check if minimum USD value is set correctly
    function testMinimumUsd() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    //to check if owner is set correctly
    function testOwner() public view {
        // assertEq(fundMe.i_owner(), address(this));
        assertEq(fundMe.getOwner(), msg.sender);
        
        console.log("Owner Address: ", fundMe.getOwner());
        console.log("Deployer Address: ", address(this)); 
        console.log("Sender Address: ", msg.sender);
        // The owner is the address that deployed the contract, which is the same as msg.sender
        // address(this) is the address of the contract that is currently executing
    }

    //to check if the version is set correctly
    function testVersion() public view{
        assertEq(fundMe.getVersion(), 4);
    }

    // to test if fund fails when the amount sent is less than the minimum USD value
    function testFund() public {
        vm.expectRevert();
        fundMe.fund{value: 0.001 ether}();
        // This should revert because 0.001 ether is less than the minimum USD value but test passes  
    }

    //to check if address to amount funded mapping is updated correctly
    function testAddressToAmountFunded() public {
        vm.prank(USER); // This makes the USER address the sender of the next transaction
        fundMe.fund{value: SEND_VALUE}(); 
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER); 
        assertEq(amountFunded, SEND_VALUE);
    }

    //so that we don't repeat the fund function call in every test
    modifier funded () {
        vm.prank(USER); 
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    //to check if the funder is added to the funders array
    function testAddFunderToArray() public funded {
        address funder = fundMe.getFunder(0); 
        assertEq(funder, USER);     
    }

    //to check if only the owner can withdraw funds
    function testOnlyOwner () public funded {
        vm.expectRevert();
        vm.prank(USER); 
        fundMe.withdraw(); // This should revert because only the owner can withdraw
        //owner is the contract deployer, not the USER
    }

    //to check if withdraw function works correctly
    function testWithdraw () public funded {

        //arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        console.log("Starting Owner Balance: ", startingOwnerBalance);
        console.log("Starting FundMe Balance: ", startingFundMeBalance);

        //act
        vm.prank(fundMe.getOwner()); // Make the owner the sender of the next transaction
        fundMe.withdraw();

        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;  
        assertEq(endingFundMeBalance, 0); // The FundMe contract balance should be 0 after withdrawal
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
        // The owner's balance should be increased by the amount withdrawn
    }

    function testWithdrawWithMultipleFunders() public {
        
        //arrange
        uint160 numberOfFunders = 10;
        for (uint160 i = 1; i < numberOfFunders; i++) {
            hoax (address(i), SEND_VALUE);
            //deal + prank in one line
            // This creates a new address with a balance of SEND_VALUE and next transaction will be sent from this address
            fundMe.fund{value: SEND_VALUE}(); // Each address funds the contract
        }  
        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        //act
        vm.startPrank(fundMe.getOwner()); 
        fundMe.withdraw();  
        vm.stopPrank();

        //assert
        assert(address(fundMe).balance == 0); // The FundMe contract balance should be 0 after withdrawal
        assert(fundMe.getOwner().balance == startingOwnerBalance + startingFundMeBalance);
    }
        
    function testExample() public pure {
        // This is a simple test that always passes
        assertTrue(true);
    }
}
