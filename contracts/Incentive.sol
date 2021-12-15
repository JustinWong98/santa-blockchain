// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// import base ERC-721 functionality
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// increment IDs when minting
import "@openzeppelin/contracts/utils/Counters.sol";

contract Incentive{
    using Counters for Counters.Counter;
    Counters.Counter public _incentiveId;

    struct incentiveNFT {
        uint256 id;
        bool isClaimed;
        address owner;
        string name;
        string description;
        string imgURL;
    }

    constructor(){
        mintIncentive(
            "Tinaes",
            "The true Santa, setting up drawnames for bootcamp students! Ho ho ho",
            "https://gateway.pinata.cloud/ipfs/QmNjaxV3gTr4i7X27XTRaJGN48uBLatGiy3stf9yLCNgJ1/Screenshot_111.png"
            );
        mintIncentive(
            "Kai",
            "The man who gifted us Rocket Academy!",
            "https://gateway.pinata.cloud/ipfs/QmNjaxV3gTr4i7X27XTRaJGN48uBLatGiy3stf9yLCNgJ1/Screenshot_110.png"
            );
    }

    incentiveNFT[] public _incentiveList;

    mapping(uint => incentiveNFT) filterByUnclaimedIncentive;
    uint incentiveCounter;

    address incentiveCustodian = 0x9E4CD52D63e332C08Ba54e80C9827bcd2cA2aEe5;

    function mintIncentive(
        string memory _name,
        string memory _description,
        string memory _incentiveURI
    ) public {
        uint256 newItemId = _incentiveId.current();
        incentiveNFT memory incentiveToken = incentiveNFT(
            newItemId,
            false,
            incentiveCustodian,
            _name,
            _description,
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
    ) external {
        // use _currentOwner?
        // below only works if incentive.sol is erc721 - causes issues as it needs to be abstract to compile
        // transferFrom(_incentiveList[_itemId].owner, _newOwner, _incentiveList[_itemId].id);
        _incentiveList[_itemId].owner =  _newOwner;
    }

    function getAllIncentive() external view returns (incentiveNFT[] memory) {
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