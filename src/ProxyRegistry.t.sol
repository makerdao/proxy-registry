pragma solidity ^0.4.18;

import "ds-test/test.sol";

import "./ProxyRegistry.sol";

contract ProxyRegistryTest is DSTest {
    ProxyRegistry registry;
    DSProxyFactory factory;

    function setUp() public {
        factory = new DSProxyFactory();
        registry = new ProxyRegistry(factory);
    }

	function test_ProxyRegistryBuild() public {
		address proxyAddr = registry.build();
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

        assertEq(registry.proxiesCount(this), 1);
        assertEq(registry.proxies(this, 0), proxy);
	}

    function test_ProxyRegistryBuildOtherOwner() public {
		address owner = address(0x123);
		address proxyAddr = registry.build(owner);
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

        assertEq(registry.proxiesCount(owner), 1);
        assertEq(registry.proxies(owner, 0), proxy);
	}
}
