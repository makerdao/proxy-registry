pragma solidity ^0.4.18;

import "ds-test/test.sol";

import "./ProxyDirectory.sol";

contract ProxyDirectoryTest is DSTest {
    ProxyDirectory directory;
    DSProxyFactory factory;

    function setUp() public {
        factory = new DSProxyFactory();
        directory = new ProxyDirectory(factory);
    }

	function test_ProxyDirectoryBuild() public {
		address proxyAddr = directory.build();
		assertTrue(proxyAddr > 0x0);
		DSProxy proxy = DSProxy(proxyAddr);

		uint codeSize;
		assembly {
			codeSize := extcodesize(proxyAddr)
		}
		//verify proxy was deployed successfully
		assertTrue(codeSize > 0);

		//verify proxy creation was logged
		assertTrue(factory.isProxy(proxyAddr));

		//verify proxy ownership
		assertEq(proxy.owner(), this);

        assertEq(directory.proxiesCount(this), 1);
        assertEq(directory.proxies(this, 0), proxy);
	}

    function test_ProxyDirectoryBuildOtherOwner() public {
		address owner = address(0x123);
		address proxyAddr = directory.build(owner);
		assertTrue(proxyAddr > 0x0);
		DSProxy proxy = DSProxy(proxyAddr);

		uint codeSize;
		assembly {
			codeSize := extcodesize(proxyAddr)
		}
		//verify proxy was deployed successfully
		assertTrue(codeSize > 0);

		//verify proxy creation was logged
		assertTrue(factory.isProxy(proxyAddr));

		//verify proxy ownership
		assertEq(proxy.owner(), owner);

        assertEq(directory.proxiesCount(owner), 1);
        assertEq(directory.proxies(owner, 0), proxy);
	}
}
