pragma solidity ^0.4.18;

import 'ds-proxy/proxy.sol';
import 'ds-auth/auth.sol';


// ProxyRegistry
// This Registry deploys new proxy instances through DSProxyFactory.build(address) and keeps a registry of owner => proxies
contract ProxyRegistry is DSAuth {
    mapping(address=>DSProxy[]) public proxies;
    mapping(address=>uint) public proxiesCount;
    mapping(address=>bool) public approvals;
    DSProxyFactory factory;

    constructor(DSProxyFactory factory_) public {
        factory = factory_;
    }

    function rely(address guy) public auth {
        approvals[guy] = true;
    }

    function deny(address guy) public auth {
        approvals[guy] = false;
    }

    // deploys a new proxy instance
    // sets owner of proxy to caller
    function build() public returns (DSProxy proxy) {
        proxy = build(msg.sender);
    }

    // deploys a new proxy instance
    // sets custom owner of proxy
    function build(address owner) public returns (DSProxy proxy) {
        require(msg.sender == owner || approvals[msg.sender]);
        proxy = factory.build(owner);
        proxies[owner].push(proxy);
        proxiesCount[owner] ++;
    }
}
