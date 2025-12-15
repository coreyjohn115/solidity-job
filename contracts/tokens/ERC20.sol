// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IERC20.sol";

/**
 * @title ERC20
 * @dev 自己实现一个ERC20代币合约
 */
abstract contract ERC20 is IERC20 {
    // 不占用存储空间
    uint8 public immutable decimals;

    // 打包小变量
    address owner;
    bool pause = false;
    uint256 public totalSupply;
    string public name;
    string public symbol;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initSupply * 10 ** _decimals;

        owner = msg.sender;
        balances[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier whenNotPaused() {
        require(!pause, "Contract is paused");
        _;
    }

    modifier validAddress(address _addr) {
        require(_addr != address(0), "Invalid address");
        _;
    }

    /**
     * @dev 获取指定地址的代币余额
     * @param addr 指定地址
     * @return 指定地址的代币余额
     */
    function balanceOf(address addr) public view returns (uint256) {
        return balances[addr];
    }

    /**
     * @dev 获取指定地址的代币余额
     * @param _owner 指定地址
     * @param _spender 授权地址
     * @return 指定地址的代币余额
     */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowances[_owner][_spender];
    }

    /**
     * @dev 转账
     * @param _to 接收地址
     * @param _value 转账数量
     * @return 是否成功
     */
    function transfer(
        address _to,
        uint256 _value
    ) public whenNotPaused validAddress(_to) returns (bool) {
        require(_value > 0, "Invalid value");

        require(balances[msg.sender] >= _value, "Insufficient balance");
        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * @dev 转账
     * @param _from 发送地址
     * @param _to 接收地址
     * @param _value 转账数量
     * @return 是否成功
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public whenNotPaused validAddress(_from) validAddress(_to) returns (bool) {
        require(_value > 0, "Invalid value");
        require(balances[_from] >= _value, "Insufficient balance");
        require(allowances[_from][msg.sender] >= _value, "Insufficient allowance");

        balances[_from] -= _value;
        balances[_to] += _value;
        allowances[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    /**
     * @dev 授权
     * @param _spender 授权地址
     * @param _value 授权数量
     * @return 是否成功
     */
    function approve(
        address _spender,
        uint256 _value
    ) public whenNotPaused validAddress(_spender) returns (bool) {
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev 铸币
     * @param _value 铸币数量
     * @return 是否成功
     */
    function mint(uint256 _value) public onlyOwner whenNotPaused returns (bool) {
        require(_value > 0, "Invalid value");

        balances[msg.sender] += _value;
        totalSupply += _value;

        emit Transfer(address(0), msg.sender, _value);
        return true;
    }

    /**
     * @dev 销毁
     * @param _value 销毁数量
     * @return 是否成功
     */
    function burn(uint256 _value) public whenNotPaused returns (bool) {
        require(_value > 0, "Invalid value");
        require(balances[msg.sender] >= _value, "Insufficient balance");

        balances[msg.sender] -= _value;
        totalSupply -= _value;

        emit Transfer(msg.sender, address(0), _value);
        return true;
    }

    /**
     * @dev 设置暂停
     * @param _pause 是否暂停
     */
    function setPause(bool _pause) public onlyOwner {
        pause = _pause;
    }

    /**
     * @dev 批量转账
     * @param _to 接收地址数组
     * @param _value 转账数量数组
     * @return 是否成功
     */
    function batchTransfer(
        address[] calldata _to,
        uint256[] calldata _value
    ) public whenNotPaused returns (bool) {
        require(_to.length > 0, "Invalid length");
        require(_to.length == _value.length, "Invalid length");

        uint totalValue = 0;
        for (uint i = 0; i < _value.length; i++) {
            totalValue += _value[i];
            require(_to[i] != address(0), "Invalid address");
        }
        require(balances[msg.sender] >= totalValue, "Insufficient balance");

        for (uint i = 0; i < _to.length; i++) {
            balances[msg.sender] -= _value[i];
            balances[_to[i]] += _value[i];
            emit Transfer(msg.sender, _to[i], _value[i]);
        }

        return true;
    }
}
