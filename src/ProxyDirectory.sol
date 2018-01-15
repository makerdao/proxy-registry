pragma solidity ^0.4.18;

import 'ds-proxy/proxy.sol';

// ProxyDirectory
// This Directory deploys new proxy instances through DSProxyFactory.build(address) and keeps a directory of owner => proxies
contract ProxyDirectory {
    mapping(address=>DSProxy[]) public proxies;
    mapping(address=>uint) public proxiesCount;
    DSProxyFactory factory;

    function ProxyDirectory(DSProxyFactory factory_) public {
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
