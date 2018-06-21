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

        assertEq(registry.proxies(this), proxy);
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

        assertEq(registry.proxies(owner), proxy);
	}

	function test_ProxyRegistryCreateNewProxy() public {
		address proxyAddr = registry.build();
		assertTrue(proxyAddr > 0x0);
		assertEq(proxyAddr, registry.proxies(this));
		DSProxy(proxyAddr).setOwner(0);
		address proxyAddr2 = registry.build();
		assertTrue(proxyAddr != proxyAddr2);
		assertEq(proxyAddr2, registry.proxies(this));
	}

	function testFail_ProxyRegistryCreateNewProxy() public {
		registry.build();
		registry.build();
	}

	function testFail_ProxyRegistryCreateNewProxy2() public {
		address owner = address(0x123);
		registry.build(owner);
		registry.build(owner);
	}
}
