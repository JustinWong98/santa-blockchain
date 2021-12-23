// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// import base ERC-721 functionality
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// increment IDs when minting
import "@openzeppelin/contracts/utils/Counters.sol";

contract Incentive {
    using Counters for Counters.Counter;
    Counters.Counter public _incentiveId;

    struct incentiveNFT {
        uint256 id;
        bool isClaimed;
        uint price;
        address owner;
        string name;
        string imgURL;
    }

    constructor() {
        mintIncentive(
            "Green Sweater Reindeer",
            1,
            "1"
        );
        mintIncentive(
            "Pingu The Penguin",
            1,
            "2"
        );
        mintIncentive(
            "Gingerbread man",
            1,
            "3"
        );
        mintIncentive(
            "Santa Claus",
            1,
            "4"
        );
        mintIncentive(
            "Santa's Little Helper 1",
            1,
            "5"
        );

        mintIncentive(
            "Frosty",
            1,
            "6"
        );
        mintIncentive(
            "Easter Bunny",
            1,
            "7"
        );
        mintIncentive(
            "Easter Bunny Imposter",
            1,
            "8"
        );
        mintIncentive(
            "Sally the Nice Girl",
            1,
            "9"
        );
        mintIncentive(
            "Ruldoph Imposter",
            1,
            "10"
        );
        mintIncentive(
            "Sadie the Naughty Girl",
            1,
            "11"
        );
        mintIncentive(
            "Girl with the Snowman Shirt",
            1,
            "12"
        );
        mintIncentive(
            "Gabriel the Angel",
            1,
            "13"
        );
        mintIncentive(
            "Sam the Nice Boy",
            1,
            "14"
        );
        mintIncentive(
            "Santa's Little Helper 2",
            1,
            "15"
        );
        mintIncentive(
            "A Bright Kid",
            1,
            "16"
        );

        mintIncentive(
            "Frosty Imposter Girl",
            1,
            "17"
        );
        mintIncentive(
            "The Giving Tree",
            1,
            "18"
        );
        mintIncentive(
            "Kane the Candy Cane",
            1,
            "19"
        );
        mintIncentive(
            "Earmuff Boy",
            1,
            "20"
        );
        mintIncentive(
            "Earmuff Girl",
            1,
            "21"
        );
        mintIncentive(
            "The Greatest Gift of All",
            1,
            "22"
        );
        mintIncentive(
            "Polar Bear",
            1,
            "23"
        );
        mintIncentive(
            "Simon the Ice King",
            1,
            "24"
        );
        mintIncentive(
            "Globehead",
            1,
            "25"
        );
        mintIncentive(
            "Frosty Imposter Boy",
            1,
            "26"
        );
        mintIncentive(
            "Angel 2",
            1,
            "27"
        );
        mintIncentive(
            "Christmas Tree Imposter",
            1,
            "31"
        );
        mintIncentive(
            "This Kid's a star!",
            1,
            "32"
        );
        mintIncentive(
            "Ruldoph",
            1,
            "33"
        );
        mintIncentive(
            "Toy Soldier",
            1,
            "39"
        );
        mintIncentive(
            "Jia En The Polar Bear",
            1,
            "50"
        );
    }

    incentiveNFT[] public _incentiveList;

    mapping(uint256 => incentiveNFT) filterByUnclaimedIncentive;
    uint256 incentiveCounter;

    address incentiveCustodian = 0x9E4CD52D63e332C08Ba54e80C9827bcd2cA2aEe5;

    function mintIncentive(
        string memory _name,
        uint _price,
        string memory _incentiveURI
    ) public {
        uint256 newItemId = _incentiveId.current();
        incentiveNFT memory incentiveToken = incentiveNFT(
            newItemId,
            false,
            _price,
            incentiveCustodian,
            _name,
            _incentiveURI
        );
        _incentiveList.push(incentiveToken);
        _incentiveId.increment();
        incentiveCounter++;
    }

    // pass in which array to use and reuse Token code?
    function transferIncentive(
        // address _currentOwner,
        address _newOwner,
        uint256 _itemId
    ) public {
        // use _currentOwner?
        // below only works if incentive.sol is erc721 - causes issues as it needs to be abstract to compile
        // transferFrom(_incentiveList[_itemId].owner, _newOwner, _incentiveList[_itemId].id);
        _incentiveList[_itemId].owner = _newOwner;
        _incentiveList[_itemId].isClaimed = true;
    }

    function getAllIncentive() public view returns (incentiveNFT[] memory) {
        return _incentiveList;
    }

    // function getUnclaimedIncentive() external view returns (incentiveNFT[] memory result) {
    //     incentiveNFT[] memory tempResult = new incentiveNFT[](incentiveCounter);
    //     uint tempCount;
    //     for (uint i = 0; i < incentiveCounter; i++) {
    //         if (_incentiveList[i].isClaimed == false) {
    //             result[tempCount] = _incentiveList[i];
    //             tempCount++;
    //         }
    //     }
    //     result = new incentiveNFT[](tempCount);
    //     for (uint j = 0; j <tempCount; j++) {
    //         result[j] = tempResult[j];
    //     }
    //     return result;
    // }
}
