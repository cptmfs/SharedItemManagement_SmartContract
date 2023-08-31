// SPDX-License-Identifier: MIT
pragma solidity 0.7.0;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SharedItemManagement.sol";

contract TestSharedItemManagement {
    // Deploy the SharedItemManagement contract for testing
    SharedItemManagement sharedItemManagement = SharedItemManagement(DeployedAddresses.SharedItemManagement());

    // Test the listSharedItem function
    function testListSharedItem() public {
        // Call the listSharedItem function to list an item
        sharedItemManagement.listSharedItem("Bike", 1 ether);
        // Retrieve the details of the listed item
        (address owner, string memory itemName, uint256 rentalPrice, , , bool isAvailable) = sharedItemManagement.sharedItems(1);

        // Check if the owner address is correct
        Assert.equal(owner, address(this), "Owner should be the address calling the function");
        // Check if the item name is set correctly
        Assert.equal(itemName, "Bike", "Item name should be 'Bike'");
        // Check if the rental price is set correctly
        Assert.equal(rentalPrice, 1 ether, "Rental price should be 1 ether");
        // Check if the item is marked as available
        Assert.isTrue(isAvailable, "Item should be available");
    }

    // Test the rentItem function
    function testRentItem() public {
        // Call the rentItem function to rent an item
        sharedItemManagement.rentItem{value: 1 ether}(1);
        // Retrieve the details of the rented item
        (, , , uint256 startTime, uint256 endTime, bool isAvailable) = sharedItemManagement.sharedItems(1);

        // Check if the start time is within a valid range
        Assert.isAtLeast(startTime, block.timestamp - 1, "Start time should be at least current block timestamp - 1");
        Assert.isAtMost(startTime, block.timestamp + 1, "Start time should be at most current block timestamp + 1");
        // Check if the end time is correctly set to 1 day after the start time
        Assert.equal(endTime, startTime + 1 days, "End time should be start time + 1 days");
        // Check if the item is marked as unavailable
        Assert.isFalse(isAvailable, "Item should not be available");
    }

    // Test the returnItem function
    function testReturnItem() public {
        // Call the returnItem function to return a rented item
        sharedItemManagement.returnItem(1);
        // Retrieve the details of the returned item
        (address owner, , uint256 rentalPrice, uint256 startTime, uint256 endTime, bool isAvailable) = sharedItemManagement.sharedItems(1);

        // Check if the owner address is correct
        Assert.equal(owner, address(this), "Owner should be the address calling the function");
        // Check if the rental price is set correctly
        Assert.equal(rentalPrice, 1 ether, "Rental price should be 1 ether");
        // Check if the start and end times are reset to 0
        Assert.equal(startTime, 0, "Start time should be reset to 0");
        Assert.equal(endTime, 0, "End time should be reset to 0");
        // Check if the item is marked as available again
        Assert.isTrue(isAvailable, "Item should be available again");
    }
}
