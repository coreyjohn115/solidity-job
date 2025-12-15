// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../tokens/ERC20.sol";

contract TokenA is ERC20 {
    constructor() ERC20("TokenA", "TA", 18, 1000) {}
}

contract TokenB is ERC20 {
    constructor() ERC20("TokenB", "TB", 18, 1000) {}
}

/**
 * @title Swap
 * @dev 交换合约
 */
contract Swap {
    ERC20 tokenA;
    ERC20 tokenB;

    event SwapEvebt(address indexed from, address indexed to, uint256 value);

    constructor(address _tokenA, address _tokenB) {
        tokenA = TokenA(_tokenA);
        tokenB = TokenB(_tokenB);
    }

    function SwapToken(uint value) public {
        require(tokenA.balanceOf(msg.sender) >= value, "Insufficient balance");

        require(tokenA.transferFrom(msg.sender, address(this), value), "Transfer 1 failed");
        require(tokenB.transfer(msg.sender, value), "Transfer 2 failed");

        emit SwapEvebt(msg.sender, address(this), value);
    }
}