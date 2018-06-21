pragma solidity ^0.4.18;

import "ds-test/test.sol";

import "./ProxyRegistry.sol";

contract FakeUser {
	function doBuild(ProxyRegistry registry, address owner) public returns (DSProxy proxy) {
		proxy = registry.build(owner);
	}

	function doRely(ProxyRegistry registry, address guy) public {
		registry.rely(guy);
	}
}

contract ProxyRegistryTest is DSTest {
    ProxyRegistry registry;
    DSProxyFactory factory;
	FakeUser user;

    function setUp() public {
        factory = new DSProxyFactory();
        registry = new ProxyRegistry(factory);
		user = new FakeUser();
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
		registry.rely(user);
		address proxyAddr = user.doBuild(registry, owner);
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

	function test_ProxyRegistryRely() public {
		registry.setOwner(user);
		user.doRely(registry, this);
		address owner = address(0x123);
		address proxyAddr = registry.build(owner);
		assertTrue(proxyAddr > 0x0);
	}

	function testFail_ProxyRegistryBuildOtherOwner() public {
		address owner = address(0x123);
		registry.build(owner);
	}

	function testFail_ProxyRegistryBuildOtherOwner2() public {
		address owner = address(0x123);
		user.doBuild(registry, owner);
	}

	function testFail_ProxyRegistryBuildOtherOwner3() public {
		address owner = address(0x123);
		registry.rely(user);
		registry.deny(user);
		user.doBuild(registry, owner);
	}

	function testFail_ProxyRegistryRely() public {
		user.doRely(registry, address(0x123));
	}
}
