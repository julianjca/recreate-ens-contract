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

    function contains(string memory what, string memory where)
        internal
        pure
        returns (bool)
    {
        bytes memory whatBytes = bytes(what);
        bytes memory whereBytes = bytes(where);

        require(whereBytes.length >= whatBytes.length);

        bool found = false;
        for (uint256 i = 0; i <= whereBytes.length - whatBytes.length; i++) {
            bool flag = true;
            for (uint256 j = 0; j < whatBytes.length; j++)
                if (whereBytes[i + j] != whatBytes[j]) {
                    flag = false;
                    break;
                }
            if (flag) {
                found = true;
                break;
            }
        }
        return found;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        if (ownerOf[id] == address(0)) revert DoesNotExist();

        string memory ensName = ensNames[id];

        string memory output = string(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: sans-serif; font-size: 16px; }</style><rect width="100%" height="100%" fill="url(#grad1)" /><text x="20" y="330" class="base">',
                ensName,
                '</text><linearGradient xmlns="http://www.w3.org/2000/svg" id="grad1" x1="190.5" y1="302" x2="-64" y2="-172.5" gradientUnits="userSpaceOnUse"><stop stop-color="#44BCF0"/><stop offset="0.428185" stop-color="#628BF3"/><stop offset="1" stop-color="#A099FF"/></linearGradient></svg>'
            )
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name":',
                        '"',
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

    function registerName(string memory nameToRegister)
        external
        returns (uint256)
    {
        string memory ensName;
        bool containsDotEth = contains(".eth", nameToRegister);

        if (containsDotEth) {
            ensName = nameToRegister;
        } else {
            ensName = string(abi.encodePacked(nameToRegister, ".eth"));
        }

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
