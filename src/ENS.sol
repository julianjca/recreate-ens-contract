// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "solmate/tokens/ERC721.sol";
// import "solmate/utils/SafeTransferLib.sol";
import "./Ownable.sol";
import "./Base64.sol";

error DoesNotExist();

contract ENS is ERC721, Ownable {
    mapping(string => address) public ensOwnerships;
    mapping(string => address) public resolvers;
    mapping(uint256 => string) public ensNames;

    constructor(string memory _name, string memory _symbol)
        payable
        ERC721(_name, _symbol)
    {}

    function isAvailable(string memory ensName) public view returns (bool) {
        if (ensOwnerships[ensName] == address(0)) {
            return true;
        }

        return false;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        if (ownerOf[id] == address(0)) revert DoesNotExist();

        string memory ensName = ensNames[id];

        string memory output = string(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">',
                ensName,
                "</text></svg>"
            )
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name":',
                        ensName,
                        '", "description": "ENS is a name service like website domain", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(output)),
                        '"}'
                    )
                )
            )
        );

        output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
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
    ) internal virtual {
        // map ENS name to the message sender
        ensOwnerships[ensName] = to;

        ensNames[id] = ensName;

        _mint(to, id);
    }

    function setResolver(string memory ensName, address newResolver) external {
        require(
            ensOwnerships[ensName] == msg.sender,
            "you don't own this ensName"
        );

        resolvers[ensName] = newResolver;
    }

    function getResolver(string memory ensName)
        external
        view
        returns (address)
    {
        return resolvers[ensName];
    }

    function checkOwnerByEnsName(string memory ensName)
        external
        view
        returns (address)
    {
        return ensOwnerships[ensName];
    }

    // function withdraw() external {
    //     require(msg.sender == _owner, "Caller is not owner");

    //     SafeTransferLib.safeTransferETH(msg.sender, address(this).balance);
    // }

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
