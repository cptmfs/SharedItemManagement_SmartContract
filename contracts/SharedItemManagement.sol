// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// Shared Item Management Smart Contract
contract SharedItemManagement {
    // Shared Item Structure
    struct SharedItem {
        address owner; // Owner
        string itemName; // Item Name
        uint256 rentalPrice; // Rental Price
        uint256 startTime; // Rental Start Time
        uint256 endTime; // Rental End Time
        bool isAvailable; // Availability Status
    }

    // Map of Shared Items (by ID)
    mapping(uint256 => SharedItem) public sharedItems;
    uint256 public itemCount; // Item Count

    // Events
    event ItemListed(uint256 itemId, address owner, string itemName, uint256 rentalPrice); // Item Listed Event
    event ItemRented(uint256 itemId, address renter, uint256 startTime, uint256 endTime); // Item Rented Event
    event ItemReturned(uint256 itemId, address renter); // Item Returned Event

    // Modifier that allows only the item owner
    modifier onlyItemOwner(uint256 itemId) {
        require(sharedItems[itemId].owner == msg.sender, "Only the owner can perform this action");
        _;
    }

    // Constructor Function (Runs when contract is created)
    constructor() {
        itemCount = 0; // Initializes item count to 0
    }

    // Function to list a shared item
    function listSharedItem(string memory itemName, uint256 rentalPrice) external {
        itemCount++; // Increases item count
        sharedItems[itemCount] = SharedItem({ // Adds new item to the map
            owner: msg.sender,
            itemName: itemName,
            rentalPrice: rentalPrice,
            startTime: 0,
            endTime: 0,
            isAvailable: true
        });

        emit ItemListed(itemCount, msg.sender, itemName, rentalPrice); // Triggers the Item Listed event
    }

    // Function to rent a shared item
    function rentItem(uint256 itemId) external payable {
        
        SharedItem storage item = sharedItems[itemId]; // Gets the item from the map
        require(msg.value >= item.rentalPrice, "Insufficient payment"); // Checks if payment is sufficient
        require(item.isAvailable, "Item is not available"); // Checks if item is available

        item.isAvailable = false; // Sets item availability to false
        item.startTime = block.timestamp; // Sets rental start time
        item.endTime = block.timestamp + 1 days; // Sets rental end time (1 day later)

        emit ItemRented(itemId, msg.sender, item.startTime, item.endTime); // Triggers the Item Rented event
    }

    // Function to return a shared item
    function returnItem(uint256 itemId) external onlyItemOwner(itemId) { // Allows only the item owner
        SharedItem storage item = sharedItems[itemId]; // Gets the item from the map
        require(!item.isAvailable, "Item is not rented"); // Checks if the item is rented

        uint256 rentalDuration = block.timestamp - item.startTime; // Calculates rental duration
        uint256 overdueFee = 0; // Initializes overdue fee to 0

        if (rentalDuration > 1 days) { 
            overdueFee = (rentalDuration - 1 days) * (item.rentalPrice / 2); 
            /* If rental duration is more than 1 day, calculates overdue fee 
            (Half of the rental price as overdue fee) */
        }

        item.isAvailable = true; // Sets item availability to true
        item.startTime = 0; // Resets rental start time
        item.endTime = 0; // Resets rental end time

        payable(msg.sender).transfer(item.rentalPrice + overdueFee); // Pays the owner the rental price + overdue fee

        emit ItemReturned(itemId, msg.sender); // Triggers the Item Returned event
    }
}
