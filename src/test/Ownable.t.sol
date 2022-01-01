// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../Ownable.sol";

contract OwnableTest is DSTest {
    Ownable internal ownable;

    function setUp() public {
        ownable = new Ownable();
    }

    function testOwnerIsMsgSender() public {
        assertEq(ownable.owner(), address(this));
    }

    function testTransferOwnership(address newOwner) public {
        ownable.transferOwnership(newOwner);
        assertEq(ownable.owner(), newOwner);
    }

    function testRenounceOwnership() public {
        ownable.renounceOwnership();

        assertEq(ownable.owner(), address(0));
    }
}
