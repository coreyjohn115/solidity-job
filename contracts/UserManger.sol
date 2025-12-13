// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserManger {
    struct User {
        address registerAt;
        bool exists;
        string name;
        string email;
        uint blance;
    }

    mapping(address => User) users;
    address[] addressArr;
    uint constant MAX = 1000;

    /**
     * @dev 注册用户
     * @param _name 用户名
     * @param _email 用户邮箱
     */
    function Register(string calldata _name, string calldata _email) public {
        require(addressArr.length <= MAX, "out of length");
        if (users[msg.sender].exists) {
            return;
        }
        User memory user = User({
            name: _name,
            email: _email,
            blance: 0,
            registerAt: msg.sender,
            exists: true
        });

        users[msg.sender] = user;
        addressArr.push(msg.sender);
    }

    /**
     * @dev 更新用户信息
     * @param _name 用户名
     * @param _email 用户邮箱
     */
    function Update(string calldata _name, string calldata _email) public {
        if (!users[msg.sender].exists) {
            return;
        }

        User storage user = users[msg.sender];
        user.name = _name;
        user.email = _email;
    }

    /**
     * @dev 存款
     */
    function Deposit() public payable {
        if (!users[msg.sender].exists) {
            return;
        }

        User storage user = users[msg.sender];
        user.blance += msg.value;
    }

    /**
     * @dev 获取用户信息
     * @param addr 用户地址
     * @return user 用户信息
     */
    function GetUser(address addr) public view returns (User memory) {
        return users[addr];
    }

    /**
     * @dev 获取所有用户信息
     * @return arr 用户信息数组
     */
    function GetAllUser() public view returns (User[] memory) {
        uint len = addressArr.length;
        User[] memory arr = new User[](len);
        for (uint i = 0; i < len; i++) {
            arr[i] = users[addressArr[i]];
        }

        return arr;
    }

    /**
     * @dev 获取指定范围内的用户信息
     * @param start 开始索引
     * @param end 结束索引
     * @return arr 用户信息数组
     */
    function GetUserByRange(
        uint start,
        uint end
    ) public view returns (User[] memory) {
        uint len = addressArr.length;
        require(start < end, "out of length");
        require(end <= len, "out of length");
        User[] memory arr = new User[](end - start);
        for (uint i = start; i < end; i++) {
            arr[i] = users[addressArr[i]];
        }

        return arr;
    }
}
