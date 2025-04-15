// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/// @custom:oz-upgrades-from OldDeepLinkCrownNFT
contract DeepLinkCrownNFT is
    Initializable,
    ERC721Upgradeable,
    OwnableUpgradeable,
    ERC721EnumerableUpgradeable,
    UUPSUpgradeable
{
    uint256 private constant ONE_MONTH = 30 days;
    uint256 private _nextTokenId;

    enum VersionType {
        ProfessionalVersion,
        TeamVersion
    }

    enum ExpireTimeType {
        OneMonths,
        ThreeMonths,
        SixMonths,
        TwelveOneAndThreeMonths
    }

    struct NFTInfo {
        VersionType versionType;
        ExpireTimeType expireTimeType;
        uint256 expireAtTimestamp;
    }

    mapping(VersionType => string) public versionType2URI;

    mapping(uint256 => NFTInfo) public tokenId2NFTInfo;

    mapping(address => mapping(VersionType => bool)) public minter2MintLevel;

    event mintedToken(address indexed to, uint256 tokenId, VersionType versionType, ExpireTimeType expireTimeType);
    event activeToken(address indexed from, uint256 tokenId, uint256 expireAtTimestamp);

    function initialize(address initialOwner) public initializer {
        __ERC721_init("DeepLinkCrownNFT", "DLCCNFT");
        __Ownable_init(initialOwner);
        __ERC721Enumerable_init();
        __UUPSUpgradeable_init();
        _nextTokenId = 1;
        _setURIConfig();
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    modifier onlyMinter2MintLevel(VersionType versionType) {
        require(minter2MintLevel[msg.sender][versionType], "Not authorized to mint this level");
        _;
    }

    function active(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Not owner");
        NFTInfo storage nftInfo = tokenId2NFTInfo[tokenId];
        require(nftInfo.expireAtTimestamp == 0, "can not active again");
        uint256 expireAtTimestamp = _getExpireTime(nftInfo.expireTimeType);
        nftInfo.expireAtTimestamp = expireAtTimestamp;
        emit activeToken(msg.sender, tokenId, expireAtTimestamp);
    }

    function safeBatchMint(address to, uint256 amount, VersionType versionType, ExpireTimeType expireTimeType)
        public
        onlyMinter2MintLevel(versionType)
    {
        for (uint256 i = 0; i < amount; i++) {
            _safeMint(to, _nextTokenId);
            tokenId2NFTInfo[_nextTokenId] = NFTInfo(versionType, expireTimeType, 0);
            emit mintedToken(to, _nextTokenId, versionType, expireTimeType);
            _nextTokenId++;
        }
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);
        NFTInfo memory nftInfo = tokenId2NFTInfo[tokenId];
        return versionType2URI[nftInfo.versionType];
    }

    function addMinter2MintLevel(address minter, VersionType versionType) external onlyOwner {
        minter2MintLevel[minter][versionType] = true;
    }

    function removeMintLevelOfMinter(address minter, VersionType versionType) external onlyOwner {
        minter2MintLevel[minter][versionType] = false;
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function getTokenIdsByAddress(address owner) external view returns (uint256[] memory) {
        uint256 balance = balanceOf(owner);
        uint256[] memory tokenIds = new uint256[](balance);

        for (uint256 i = 0; i < balance; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(owner, i);
        }

        return tokenIds;
    }

    function getActiveTokenIdsByAddress(address owner) external view returns (uint256[] memory) {
        uint256 balance = balanceOf(owner);

        uint256 activeCount;
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(owner, i);
            if (block.timestamp < tokenId2NFTInfo[tokenId].expireAtTimestamp) {
                activeCount++;
            }
        }

        uint256[] memory tokenIds = new uint256[](activeCount);

        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(owner, i);
            if (block.timestamp < tokenId2NFTInfo[tokenId].expireAtTimestamp) {
                tokenIds[i] = tokenId;
            }
        }

        return tokenIds;
    }

    function _getExpireTime(ExpireTimeType expireTimeType) internal view returns (uint256) {
        // return block.timestamp + 12 * ONE_MONTH;
        if (expireTimeType == ExpireTimeType.OneMonths) {
            return block.timestamp + ONE_MONTH;
        }
        if (expireTimeType == ExpireTimeType.ThreeMonths) {
            return block.timestamp + 3 * ONE_MONTH;
        }
        if (expireTimeType == ExpireTimeType.SixMonths) {
            return block.timestamp + 6 * ONE_MONTH;
        }
        if (expireTimeType == ExpireTimeType.TwelveOneAndThreeMonths) {
            return block.timestamp + 12 * ONE_MONTH;
        }
        revert("Invalid expire time type");
    }

    function _setURIConfig() internal {
        versionType2URI[VersionType.ProfessionalVersion] =
            "https://raw.githubusercontent.com/DeepLinkProtocol/DeepLinkNodeNFTContact/crownNFT/resource/metadata/1.json";
        versionType2URI[VersionType.TeamVersion] =
            "https://raw.githubusercontent.com/DeepLinkProtocol/DeepLinkNodeNFTContact/crownNFT/resource/metadata/2.json";
    }

    function version() public pure returns (uint256) {
        return 0;
    }
}
