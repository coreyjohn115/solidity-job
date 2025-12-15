// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title 多签钱包合约
 * @dev 实现M-of-N多重签名机制的钱包合约
 * @author MetaNode
 */
contract MulSignature {
    // 事件定义
    event Deposit(address indexed sender, uint256 amount, uint256 balance);
    event SubmitTransaction(
        address indexed owner,
        uint256 indexed txIndex,
        address indexed to,
        uint256 value,
        bytes data
    );
    event ConfirmTransaction(address indexed owner, uint256 indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint256 indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint256 indexed txIndex);

    // 状态变量
    address[] public owners; // 所有者数组
    mapping(address => bool) public isOwner; // 检查是否为所有者
    uint256 public numConfirmationsRequired; // 需要的确认数量

    // 交易结构体
    struct Transaction {
        address to; // 目标地址
        uint256 value; // 转账金额
        bytes data; // 交易数据
        bool executed; // 是否已执行
        uint256 numConfirmations; // 当前确认数量
    }

    // 交易数组和确认映射
    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public isConfirmed;

    // 修饰符
    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transactions.length, "transaction does not exist");
        _;
    }

    modifier notExecuted(uint256 _txIndex) {
        require(!transactions[_txIndex].executed, "transaction already executed");
        _;
    }

    modifier notConfirmed(uint256 _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "transaction already confirmed");
        _;
    }

    /**
     * @dev 构造函数
     * @param _owners 所有者地址数组
     * @param _numConfirmationsRequired 需要的确认数量
     */
    constructor(address[] memory _owners, uint256 _numConfirmationsRequired) {
        require(_owners.length > 0, "owners required");
        require(
            _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
            "invalid number of required confirmations"
        );

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        numConfirmationsRequired = _numConfirmationsRequired;
    }

    /**
     * @dev 接收以太币
     */
    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    /**
     * @dev 提交交易
     * @param _to 目标地址
     * @param _value 转账金额
     * @param _data 交易数据
     */
    function submitTransaction(address _to, uint256 _value, bytes memory _data) public onlyOwner {
        uint256 txIndex = transactions.length;

        transactions.push(
            Transaction({to: _to, value: _value, data: _data, executed: false, numConfirmations: 0})
        );

        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }

    /**
     * @dev 确认交易
     * @param _txIndex 交易索引
     */
    function confirmTransaction(
        uint256 _txIndex
    ) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) notConfirmed(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        transaction.numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;

        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    /**
     * @dev 执行交易
     * @param _txIndex 交易索引
     */
    function executeTransaction(
        uint256 _txIndex
    ) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];

        require(transaction.numConfirmations >= numConfirmationsRequired, "cannot execute tx");

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value, gas: 10000}(transaction.data);
        require(success, "tx failed");

        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    /**
     * @dev 撤销确认
     * @param _txIndex 交易索引
     */
    function revokeConfirmation(
        uint256 _txIndex
    ) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];

        require(isConfirmed[_txIndex][msg.sender], "tx not confirmed");

        transaction.numConfirmations -= 1;
        isConfirmed[_txIndex][msg.sender] = false;

        emit RevokeConfirmation(msg.sender, _txIndex);
    }

    /**
     * @dev 获取所有者列表
     */
    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    /**
     * @dev 获取交易数量
     */
    function getTransactionCount() public view returns (uint256) {
        return transactions.length;
    }

    /**
     * @dev 获取交易详情
     * @param _txIndex 交易索引
     */
    function getTransaction(
        uint256 _txIndex
    )
        public
        view
        returns (
            address to,
            uint256 value,
            bytes memory data,
            bool executed,
            uint256 numConfirmations
        )
    {
        Transaction storage transaction = transactions[_txIndex];

        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }

    /**
     * @dev 获取合约余额
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
