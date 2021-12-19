// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Token.sol";
import "./Incentive.sol";

contract Wishlist is SantaToken, Incentive {
    using Counters for Counters.Counter;
    Counters.Counter public _userIds;
    // map to wish
    // use the ids generated in our token
    mapping(uint256 => address) public wishes;
    // map inapp currency
    struct User {
        uint256 id;
        uint256 totalPoints;
        uint256 currentPoints;
        address userAddress;
        bool exists;
    }

    User[] public _users;
    address[] public _userAddresses;
    mapping(address => User) allUsers;

    // if user hasn't joined before
    function initUser(address _from) public {
        uint256 newUserId = _userIds.current();
        User memory newUser = User(newUserId, 0, 0, _from, true);
        _users.push(newUser);
        _userAddresses.push(_from);
        allUsers[_from] = newUser;
        _userIds.increment();
    }

    // create a wish
    function createWish(address _from, uint256 _itemId) public {
        require(wishes[_itemId] == address(0));
        wishes[_itemId] = _from;
        _listed[_itemId].wisher = _from;
        _listed[_itemId].wishCreated = true;
        filterByWishCreated[createdWishCounter] = _listed[_itemId];
        createdWishCounter++;
    }

    // fulfill a wish
    function buyWish(address _from, uint256 _itemId) public payable {
        uint256 price = displayPrice(_itemId);
        uint256 amountPaid = msg.value;
        require(amountPaid >= price);
        address payable smartContractor = payable(displayContractor(_itemId));
        smartContractor.transfer(amountPaid);
        // then smart contract releases the nft to the wishmaker
        // token.transferNFT(wishes[_itemId], _itemId);
        markAsSold(_itemId);
        // we need to store the buyers address which is tied to the NFT now
        setGifter(_itemId, _from);
        // need to check if address exists in our users
        if (allUsers[_from].exists != true) {
            initUser(_from);
        }
        allUsers[_from].currentPoints++;
        allUsers[_from].totalPoints++;
    }

    // redeem incentve
    function redeem(address _from, uint256 _itemId) public {
        // may need to change 0 to how much the NFT costs
        require(
            allUsers[_from].currentPoints > 0,
            "You do not have enough points!"
        );
        require(
           allUsers[_from].currentPoints >= _incentiveList[_itemId].price,
           "You do not have the points to redeem this incentive!"
        );
        allUsers[_from].currentPoints--;
        // incentive nft now points to _from
        transferIncentive(_from, _itemId);
        // do we need to change owner manually?
    }

    // view points
    function getPoints(address _from) public view returns (uint256) {
        return allUsers[_from].currentPoints;
    }

    function getAllUsers() public view returns (User[] memory) {
        uint currentUsersLength = _userIds.current();
        User[] memory ret = new User[](currentUsersLength);
        for (uint i = 0; i < currentUsersLength; i++) {
            ret[i] = allUsers[_userAddresses[i]];
        }
        return ret;
    }

    function getOwner(uint256 _itemId) public view returns (address) {
        return ownerOf(_itemId);
    }
}
