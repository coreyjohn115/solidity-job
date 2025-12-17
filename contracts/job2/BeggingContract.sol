// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title BeggingContract
 * @dev 讨饭合约
 */
contract BeggingContract {
    uint private startTime;
    uint private endTime;
    mapping(address => uint) public votes;
    address[3] public top3;

    address owner;

    event DonateEvent(address indexed donor, uint amount);
    event WithdrawEvent(address indexed owner, uint amount);

    constructor() {
        owner = msg.sender;
        startTime = block.timestamp;
        endTime = startTime + 7 days; // 30天
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier inTime() {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Not in time");
        _;
    }

    /**
     * @dev 捐款
     */
    function donate() public payable inTime {
        require(msg.value > 0, "Invalid amount");
        votes[msg.sender] += msg.value;

        for (uint i = 0; i < 3; ) {
            if (votes[top3[i]] < votes[msg.sender]) {
                top3[i] = msg.sender;
                break;
            }

            unchecked {
                i++;
            }
        }

        emit DonateEvent(msg.sender, msg.value);
    }

    /**
     * @dev 提现
     */
    function withdraw() public onlyOwner {
        uint amount = address(this).balance;
        require(amount > 0, "No balance to withdraw");
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdraw failed");

        emit WithdrawEvent(msg.sender, amount);
    }

    /**
     * @dev 获取捐款
     * @param donor 捐款者地址
     * @return 捐款者捐款金额
     */
    function getDonation(address donor) public view returns (uint) {
        return votes[donor];
    }

    /**
     * @dev 获取总捐款
     * @return 总捐款金额
     */
    function getTotalDonation() public view returns (uint) {
        return address(this).balance;
    }

    /**
     * @dev 获取捐款前3名地址
     * @return 前3名地址
     */
    function getTop3() public view returns (address[3] memory) {
        return top3;
    }
}
