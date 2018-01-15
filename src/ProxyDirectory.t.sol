pragma solidity ^0.4.19;

import "ds-test/test.sol";

import "./ProxyDirectory.sol";

contract ProxyDirectoryTest is DSTest {
    ProxyDirectory directory;

    function setUp() public {
        directory = new ProxyDirectory();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
