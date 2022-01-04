// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../ENS.sol";

contract ENSTest is DSTest {
    ENS internal token;

    function setUp() public {
        token = new ENS("Ethereum Name Service", "ENS");
    }

    function testMetadata() public {
        assertEq(token.name(), "Ethereum Name Service");
        assertEq(token.symbol(), "ENS");
    }

    // function testRegister(string memory ensName) public {
    //     uint256 id = token.registerName(ensName);

    //     // check the owner by ENS name
    //     address addressOwner = token.checkOwnerByEnsName(ensName);

    //     // check ownerOf
    //     address tokenOwner = token.ownerOf(id);

    //     assertEq(tokenOwner, address(this));
    //     assertEq(addressOwner, address(this));
    // }

    function testCheckAvailability() public {
        string memory ensName = "akak.eth";

        bool isAvailable = token.isAvailable(ensName);

        assertTrue(isAvailable);
    }

    function testCheckAvailabilityAfterMinting() public {
        string memory ensName = "test145.eth";
        token.registerName(ensName);

        bool isAvailable = token.isAvailable(ensName);

        assertTrue(!isAvailable);
    }

    function testResolver() public {
        string memory ensName = "test145.eth";
        token.registerName(ensName);
        token.setResolver(ensName, address(this));
        address resolver = token.getResolver(ensName);

        assertEq(resolver, address(this));
    }

    function testRegisterHasDotEthName() public {
        string memory ensName = "test145.eth";

        uint256 id = token.registerName(ensName);

        // check the owner by ENS name
        address addressOwner = token.checkOwnerByEnsName(ensName);

        // check ownerOf
        address tokenOwner = token.ownerOf(id);

        assertEq(tokenOwner, address(this));
        assertEq(addressOwner, address(this));
    }

    function testRegisterHasNoDotEthName() public {
        string memory ensName = "test123";

        uint256 id = token.registerName(ensName);

        string memory ensNameWithDotEth = string(
            abi.encodePacked(ensName, ".eth")
        );

        // check the owner by ENS name
        address addressOwner = token.checkOwnerByEnsName(ensNameWithDotEth);

        // check ownerOf
        address tokenOwner = token.ownerOf(id);

        assertEq(tokenOwner, address(this));
        assertEq(addressOwner, address(this));
    }
}
