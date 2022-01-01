// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../Ownable.sol";

contract OwnableTest is DSTest {
    Ownable token;

    function setUp() public {
        token = new Ownable();
    }

    function testOwnerIsMsgSender() public {
        assertEq(token.onwer(), address(this));
    }
}
