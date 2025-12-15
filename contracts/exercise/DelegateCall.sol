// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 逻辑合约需要与代理合约有相同的存储布局
contract Logic1 {
    address public owner; // 与代理合约保持一致
    address public implementation; // 与代理合约保持一致

    function getName() external pure returns (string memory) {
        return "Logic1";
    }

    function getVersion() external pure returns (uint256) {
        return 1;
    }
}

contract Logic2 {
    address public owner; // 与代理合约保持一致
    address public implementation; // 与代理合约保持一致

    function getName() external pure returns (string memory) {
        return "Logic2";
    }

    function getVersion() external pure returns (uint256) {
        return 2;
    }
}

contract Proxy {
    address public owner;
    address public implementation;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setImplementation(address _implementation) external onlyOwner {
        implementation = _implementation;
    }

    // 添加回退函数来处理所有调用
    fallback() external payable {
        address impl = implementation;
        require(impl != address(0), "implementation not set");

        assembly {
            // 复制调用数据
            calldatacopy(0, 0, calldatasize())

            // 执行delegatecall
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)

            // 复制返回数据
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    receive() external payable {}
}
