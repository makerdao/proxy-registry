// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity >=0.5.0;

import "ds-test/test.sol";

import "./ProxyRegistry.sol";

contract ProxyRegistryTest is DSTest {
    ProxyRegistry registry;
    DSProxyFactory factory;

    function setUp() public {
        factory = new DSProxyFactory();
        registry = new ProxyRegistry(address(factory));
    }

    function test_ProxyRegistryBuild() public {
		address payable proxyAddr = registry.build();
		assertTrue(proxyAddr != address(0));
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
		assertEq(proxy.owner(), address(this));

		assertEq(address(registry.proxies(address(this))), proxyAddr);
	}

	function test_ProxyRegistryBuildOtherOwner() public {
		address owner = address(0x123);
		address payable proxyAddr = registry.build(owner);
		assertTrue(proxyAddr != address(0));
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

		assertEq(address(registry.proxies(owner)), address(proxy));
	}

	function test_ProxyRegistryCreateNewProxy() public {
		address payable proxyAddr = registry.build();
		assertTrue(proxyAddr != address(0));
		assertEq(proxyAddr, address(registry.proxies(address(this))));
		DSProxy(proxyAddr).setOwner(address(0));
		address payable proxyAddr2 = registry.build();
		assertTrue(proxyAddr != proxyAddr2);
		assertEq(proxyAddr2, address(registry.proxies(address(this))));
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
