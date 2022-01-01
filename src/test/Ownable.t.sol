// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../Ownable.sol";

contract OwnableTest is DSTest {
    Ownable internal token;

    function setUp() public {
        token = new Ownable();
    }

    function testOwnerIsMsgSender() public {
        assertEq(token.owner(), address(this));
    }

    function testTransferOwnership() public {
        address newOwner = 0xeb2d7106A5728ACCBdBe380C152e2307a0Cc8FAf;
        token.transferOwnership(newOwner);
        assertEq(token.owner(), newOwner);
    }

    function testRenounceOwnership() public {
        token.renounceOwnership();

        assertEq(token.owner(), address(0));
    }
}
