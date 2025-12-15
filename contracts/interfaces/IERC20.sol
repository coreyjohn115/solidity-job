// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IERC20
 * @dev ERC20接口
 */
interface IERC20 {
    /**
     * @dev 获取总供应量
     * @return 总供应量
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev 获取指定地址的代币余额
     * @param owner 指定地址
     * @return 指定地址的代币余额
     */
    function balanceOf(address owner) external view returns (uint256);

    /**
     * @dev 获取指定地址的授权余额
     * @param owner 指定地址
     * @param spender 授权地址
     * @return 指定地址的授权余额
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev 转账
     * @param to 接收地址
     * @param value 转账金额
     * @return 是否成功
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev 授权
     * @param spender 授权地址
     * @param value 授权金额
     * @return 是否成功
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev 转账
     * @param from 转账地址
     * @param to 接收地址
     * @param value 转账金额
     * @return 是否成功
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}
