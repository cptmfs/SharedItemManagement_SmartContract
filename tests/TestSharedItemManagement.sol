// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SharedItemManagement.sol";

contract TestSharedItemManagement {
    SharedItemManagement sharedItemManagement = SharedItemManagement(DeployedAddresses.SharedItemManagement());

    // Test the listSharedItem function
    function testListSharedItem() public {
        sharedItemManagement.listSharedItem("Bike", 1 ether);
        (address owner, string memory itemName, uint256 rentalPrice, , , bool isAvailable) = sharedItemManagement.sharedItems(1);

        Assert.equal(owner, address(this), "Owner should be the address calling the function");
        Assert.equal(itemName, "Bike", "Item name should be 'Bike'");
        Assert.equal(rentalPrice, 1 ether, "Rental price should be 1 ether");
        Assert.isTrue(isAvailable, "Item should be available");
    }

    // Test the rentItem function
    function testRentItem() public {
        sharedItemManagement.rentItem{value: 1 ether}(1);
        (, , , uint256 startTime, uint256 endTime, bool isAvailable) = sharedItemManagement.sharedItems(1);

        Assert.isAtLeast(startTime, block.timestamp - 1, "Start time should be at least current block timestamp - 1");
        Assert.isAtMost(startTime, block.timestamp + 1, "Start time should be at most current block timestamp + 1");
        Assert.equal(endTime, startTime + 1 days, "End time should be start time + 1 days");
        Assert.isFalse(isAvailable, "Item should not be available");
    }

    // Test the returnItem function
    function testReturnItem() public {
        sharedItemManagement.returnItem(1);
        (address owner, , uint256 rentalPrice, uint256 startTime, uint256 endTime, bool isAvailable) = sharedItemManagement.sharedItems(1);

        Assert.equal(owner, address(this), "Owner should be the address calling the function");
        Assert.equal(rentalPrice, 1 ether, "Rental price should be 1 ether");
        Assert.equal(startTime, 0, "Start time should be reset to 0");
        Assert.equal(endTime, 0, "End time should be reset to 0");
        Assert.isTrue(isAvailable, "Item should be available again");
    }
}
