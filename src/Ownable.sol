// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

contract Ownable {
    address internal _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = msg.sender;
    }

    function onwer() external view returns (address) {
        return _owner;
    }

    function transferOwnership(address _newOwner) external {
        require(msg.sender == _owner, "caller is not owner");

        _owner = _newOwner;

        emit OwnershipTransferred(_owner, _newOwner);
    }

    function renounceOwnership() public {
        require(msg.sender == _owner, "caller is not owner");

        _owner = address(0);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        pure
        virtual
        returns (bool)
    {
        return interfaceId == 0x7f5828d0; // ERC165 Interface ID for ERC173
    }
}
