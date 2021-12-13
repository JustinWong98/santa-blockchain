// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// import base ERC-721 functionality
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// increment IDs when minting
import "@openzeppelin/contracts/utils/Counters.sol";

contract Incentive is ERC721URIStorage{
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
    incentiveNFT[] public _incentiveList;
    constructor() ERC721("SantaIncentive", "SNIC"){
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
    address custodian;

    function mintIncentive(
        string memory _name,
        string memory _description,
        string memory _incentiveURI
    ) public {
        uint256 newItemId = _incentiveId.current();
        incentiveNFT memory incentiveToken = incentiveNFT(
            newItemId,
            false,
            custodian,
            _name,
            _description,
            _incentiveURI
        );
        _incentiveList.push(incentiveToken);
        _incentiveId.increment();
    }

    // pass in which array to use and reuse Token code?
    function transferIncentive(
        // address _currentOwner,
        address _newOwner,
        uint256 _itemId
    ) external {
        // use _currentOwner?
        transferFrom(_incentiveList[_itemId].owner, _newOwner, _incentiveList[_itemId].id);
    }
}