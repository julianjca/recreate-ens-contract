// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "solmate/tokens/ERC721.sol";
import "solmate/utils/SafeTransferLib.sol";
import "./Ownable.sol";

error DoesNotExist();

contract ENS is ERC721, Ownable {
    uint256 public constant TOTAL_SUPPLY = 10_000;
    uint256 public constant PRICE_PER_MINT = 0.05 ether;

    string public baseURI;

    mapping(string => address) public ensOwnership;
    mapping(string => address) public resolver;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    ) payable ERC721(_name, _symbol) {
        baseURI = _baseURI;
    }

    function isAvailable(string memory ensName) external view returns (bool) {
        if (ensOwnership[ensName] == address(0)) {
            return true;
        }

        return false;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        if (ownerOf[id] == address(0)) revert DoesNotExist();

        return string(abi.encodePacked(baseURI, id));
    }

    function registerName(string memory ensName) external returns (uint256) {
        require(isAvailable(ensName), "ensName already registered");

        uint256 id = totalSupply + 1;

        _register(id, msg.sender, ensName);

        return id;
    }

    function _register(
        uint256 id,
        address to,
        string memory ensName
    ) internal virtual returns (uint256) {
        // map ENS name to the message sender
        ensOwnership[ensName] = to;

        _mint(to, id);
    }

    function setResolver(string memory ensName, address newResolver)
        external
        returns (bool)
    {
        require(
            ensOwnership[ensName] == msg.sender,
            "you don't own this ensName"
        );

        resolver[ensName] = newResolver;
    }

    function checkOwnerByEnsName(string memory ensName)
        external
        view
        returns (address)
    {
        return ensOwnership[ensName];
    }

    function withdraw() external {
        require(msg.sender == _owner, "Caller is not owner");

        SafeTransferLib.safeTransferETH(msg.sender, address(this).balance);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        pure
        override(ERC721, Ownable)
        returns (bool)
    {
        return
            interfaceId == 0x7f5828d0 || // ERC165 Interface ID for ERC173
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f || // ERC165 Interface ID for ERC165
            interfaceId == 0x01ffc9a7; // ERC165 Interface ID for ERC721Metadata
    }
}
