// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../ENS.sol";

contract ENSTest is DSTest {
    ENS internal token;

    function setUp() public {
        token = new ENS("Ethereum Name Service", "ENS", "ipfs://abc123");
    }

    function testMetadata() public {
        assertEq(token.name(), "Ethereum Name Service");
        assertEq(token.symbol(), "ENS");
    }

    function testBaseURI() public {
        assertEq(token.baseURI(), "ipfs://abc123");
    }
}
