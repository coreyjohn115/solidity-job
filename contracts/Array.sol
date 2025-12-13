// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Array {
    uint[] data;
    uint constant MAX = 10;

    function SafeAdd(uint value) public {
        require(data.length < MAX, unicode"数组长度超过限制");
        data.push(value);
    }

    function DeleteOrder(uint index) public {
        uint len = data.length;
        require(index < len, unicode"索引位置错误");
        uint[] storage arr = data;
        for (uint i = index + 1; i < len; i++) {
            arr[i - 1] = arr[i];
        }

        data.pop();
    }

    function Delete(uint index) public {
        uint len = data.length;
        require(index < len, unicode"索引位置错误");
        data[index] = data[len - 1];
        data.pop();
    }

    function SumRange(uint start, uint end) public view returns (uint) {
        uint len = data.length;
        require(start < len, unicode"索引位置错误");
        require(end < len, unicode"索引位置错误");
        uint[] memory arr = data;
        uint value = 0;
        for (uint i = start; i < end; i++) {
            value = value + arr[i];
        }
        return value;
    }

    function GetArr() public view returns (uint[] memory) {
        return data;
    }

    function Get(uint index) public view returns (uint) {
        uint len = data.length;
        require(index < len, unicode"索引位置错误");
        return data[index];
    }
}
