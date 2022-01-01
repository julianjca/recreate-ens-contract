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

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    ) payable ERC721(_name, _symbol) {
        baseURI = _baseURI;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        if (ownerOf[id] == address(0)) revert DoesNotExist();

        return string(abi.encodePacked(baseURI, id));
    }

    function withdraw() external {
        // if (msg.sender != _owner) revert NotOwner();

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
