// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// import base ERC-721 functionality
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// increment IDs when minting
import "@openzeppelin/contracts/utils/Counters.sol";

contract SantaToken is ERC721URIStorage {
    // using SafeMath for uint256;
    using Counters for Counters.Counter;
    // uint256 public tokenPrice = 200000000000000;
    Counters.Counter public _tokenIds;
    NFTForSale[] public _listed;
    address custodian;
    struct NFTForSale {
        uint256 id;
        uint256 price;
        bool isSold;
        bool wishCreated;
        address wisher;
        // may not need this since we have it in wishlist already as a mapping
        address owner;
        // global storage of contractor address, won't be reset
        address contractor;
        // gifter should just be one of our accounts until it is actually gifted
        address gifter;
        string name;
        string baseName;
        string description;
        string imgURL;
    }
    struct itemBase {
        string name;
        uint256 price;
    }
    itemBase[] public _itemBase;
    mapping(uint256 => NFTForSale) filterByWishCreated;
    uint256 createdWishCounter;

    constructor() ERC721("SantaToken", "SNTA") {
        custodian = msg.sender;
        createBase("Pet Dragon", 100000000000000000);
        createBase("Cute Puppy", 5000000000000000);
        createBase("Rocket Academy T-shirt", 1000000000000000);
        createBase("Grand Candy 5-Ton Chocolate Bar", 7000000000000000);
        createBase("A Real Unicorn", 80000000000000000);
        createBase("Gingerbread Bungalow", 80000000000000000);
        createBase("Balenciaga Grocery Bag", 7000000000000000);
        createBase("Silver Stapler Pins", 3000000000000000);
        createBase("Gold-Coated Toilet Paper", 5000000000000000);
        createBase("Diamond-Coated Contact Lenses", 2000000000000000);
        createBase("Ruby-Studded Pen", 1000000000000000);
        createBase("Crystal Chess Set", 2000000000000000);
        createBase("Magnetic Floating Bed", 12000000000000000);
        createBase("Snow Machine", 1000000000000000);
        createBase("Pet Pig", 3000000000000000);
        createBase("Bathtub of Victoria Ice Cream", 6000000000000000);
        createBase("Coal", 1000000000000000);
        createBase("Kanye West Designed T-shirt", 1000000000000000);
        createBase("Parada Paper Clips", 1000000000000000);
        createBase("Poppy Flowers by van Gogh", 60000000000000000);
        createBase("Pet Dinosaur", 70000000000000000);
        createBase("Invisibility Cloak", 40000000000000000);
        createBase("Real Magic Wand", 10000000000000000);
        createBase("Magic Carpet", 30000000000000000);
        createBase("Flying Broomstick", 20000000000000000);
        createBase("Mistletoe", 1000000000000000);
        createBase("School Bus", 7000000000000000);
        createBase("Time Machine", 20000000000000000);
        createBase("Pony", 4000000000000000);
        createBase("Nerf Gun", 1000000000000000);
    }

    function mintNFT(
        string memory _tokenURI,
        uint256 price,
        string memory _name,
        string memory _baseName,
        string memory _description
    ) public {
        uint256 newItemId = _tokenIds.current();

        // in case we want them to be able to mint their own nfts as a stretch goal
        // for now, it could just be whoever our creator address/custodian is
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        // custodian can transfer
        // approve(custodian, newItemId);

        NFTForSale memory token = NFTForSale(
            newItemId,
            price,
            false,
            true,
            msg.sender,
            msg.sender,
            msg.sender,
            msg.sender,
            _name,
            _baseName,
            _description,
            _tokenURI
        );
        _listed.push(token);
        _tokenIds.increment();
    }

    // display price of NFT
    function displayPrice(uint256 _itemId) public view returns (uint256) {
        NFTForSale storage nftOnSale = _listed[_itemId];
        return nftOnSale.price;
    }

    // display price of NFT
    function displayContractor(uint256 _itemId)
        internal
        view
        returns (address)
    {
        NFTForSale storage nftOnSale = _listed[_itemId];
        return nftOnSale.contractor;
    }

    // called by wishlist - custodian account
    // ERC721 version
    function transferNFT(
        // address _currentOwner,
        address _newOwner,
        uint256 _itemId
    ) external {
        // use _currentOwner?
        _transfer(_listed[_itemId].owner, _newOwner, _listed[_itemId].id);
    }

    function markAsSold(uint256 _itemId) public {
        NFTForSale storage nft = _listed[_itemId];
        nft.isSold = true;
    }

    function setGifter(uint256 _itemId, address _gifter) public {
        NFTForSale storage nft = _listed[_itemId];
        nft.gifter = _gifter;
    }

    function getAllListed() external view returns (NFTForSale[] memory) {
        return _listed;
    }

    function getAllBase() external view returns (itemBase[] memory) {
        return _itemBase;
    }

    function createBase(string memory _name, uint256 _price) public {
        itemBase memory base = itemBase(_name, _price);
        _itemBase.push(base);
    }

    // To remove or refactor
    // function getWishCreated() external view returns (NFTForSale[] memory) {
    //     NFTForSale[] memory wishesCreated = new NFTForSale[](createdWishCounter);
    //     // uint default value is 0
    //     uint tempCount;
    //     for (uint i = 0; i < _listed.length; i++) {
    //         if (_listed[i].wishCreated == true) {
    //             wishesCreated[tempCount] = _listed[i];
    //             tempCount++;
    //         }
    //     }
    //     return wishesCreated;
    // }

    // To remove or refactor
    // function getWishUncreated() external view returns (NFTForSale[] memory) {
    //     uint uncreatedWishLength = _listed.length - createdWishCounter;
    //     NFTForSale[] memory wishesUncreated = new NFTForSale[](uncreatedWishLength);
    //     // uint default value is 0
    //     uint tempCount;
    //     for (uint i = 0; i < _listed.length; i++) {
    //         if (_listed[i].wishCreated != true) {
    //             wishesUncreated[tempCount] = _listed[i];
    //             tempCount++;
    //         }
    //     }
    //     return wishesUncreated;
    // }
}
