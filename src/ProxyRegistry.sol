pragma solidity ^0.4.18;

import 'ds-proxy/proxy.sol';

// ProxyRegistry
// This Registry deploys new proxy instances through DSProxyFactory.build(address) and keeps a registry of owner => proxies
contract ProxyRegistry {
    mapping(address=>DSProxy[]) public proxies;
    mapping(address=>uint) public proxiesCount;
    DSProxyFactory factory;

    constructor(DSProxyFactory factory_) public {
        factory = factory_;
    }

    // deploys a new proxy instance
    // sets owner of proxy to caller
    function build() public returns (DSProxy proxy) {
        proxy = build(msg.sender);
    }

    // deploys a new proxy instance
    // sets custom owner of proxy
    function build(address owner) public returns (DSProxy proxy) {
        proxy = factory.build(owner);
        proxies[owner].push(proxy);
        proxiesCount[owner] ++;
    }
}
