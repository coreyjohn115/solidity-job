// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library Math {
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }
}

abstract contract Inherit {
    function test() public pure returns (string memory) {
        return "test";
    }

    function virtual1() internal pure virtual returns (string memory) {
        return "virtual1";
    }
}

contract Inherit2 is Inherit {
    using Math for uint;
    function caculate(uint256 a, uint256 b) public pure returns (uint256) {
        return a.add(b);
    }
}
