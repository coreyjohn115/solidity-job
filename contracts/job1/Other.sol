// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Other
 * @dev 实现一个其他合约
 */
contract Other {
    /**
     * @dev 反转字符串
     * @param s 字符串
     * @return result 反转后的字符串
     */
    function ReverseString(string calldata s) public pure returns (string memory) {
        uint len = bytes(s).length;
        bytes memory result = new bytes(len);
        bytes memory sBytes = bytes(s);
        for (uint i = 0; i < len; i++) {
            result[i] = sBytes[len - i - 1];
        }
        return string(result);
    }

    // 整数转罗马数字
    function IntToRoman(uint num) public pure returns (string memory) {
        require(num > 0 && num <= 3999, "Number must be between 1 and 3999");

        // 罗马数字符号和对应的数值
        string[13] memory symbols = [
            "M",
            "CM",
            "D",
            "CD",
            "C",
            "XC",
            "L",
            "XL",
            "X",
            "IX",
            "V",
            "IV",
            "I"
        ];
        uint[13] memory values = [uint(1000), 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
        string memory result = "";

        for (uint i = 0; i < 13; i++) {
            while (num >= values[i]) {
                result = string(abi.encodePacked(result, symbols[i]));
                num -= values[i];
            }
        }

        return result;
    }

    // 罗马数字转整数
    function RomanToInt(string calldata s) public pure returns (uint) {
        bytes memory romanBytes = bytes(s);
        require(romanBytes.length > 0, "Input string cannot be empty");

        uint result = 0;
        uint prevValue = 0;

        for (uint i = romanBytes.length; i > 0; i--) {
            uint currentValue = getRomanValue(romanBytes[i - 1]);
            require(currentValue > 0, "Invalid Roman numeral character");

            if (currentValue < prevValue) {
                result -= currentValue;
            } else {
                result += currentValue;
            }
            prevValue = currentValue;
        }

        return result;
    }

    // 辅助函数：获取罗马数字字符对应的数值
    function getRomanValue(bytes1 char) private pure returns (uint) {
        if (char == "I") return 1;
        if (char == "V") return 5;
        if (char == "X") return 10;
        if (char == "L") return 50;
        if (char == "C") return 100;
        if (char == "D") return 500;
        if (char == "M") return 1000;
        return 0;
    }

    // 合并两个有序数组
    function MergerSortedArray(
        uint[] calldata arr1,
        uint[] calldata arr2
    ) public pure returns (uint[] memory) {
        uint len1 = arr1.length;
        uint len2 = arr2.length;
        uint[] memory result = new uint[](len1 + len2);

        uint i = 0;
        uint j = 0;
        uint k = 0;
        while (i < len1 && j < len2) {
            if (arr1[i] < arr2[j]) {
                result[k++] = arr1[i++];
            } else {
                result[k++] = arr2[j++];
            }
        }
        while (i < len1) {
            result[k++] = arr1[i++];
        }
        while (j < len2) {
            result[k++] = arr2[j++];
        }
        return result;
    }

    // 二分查找
    function BinarySearch(uint[] calldata arr, uint target) public pure returns (int) {
        if (arr.length == 0) return -1;

        uint left = 0;
        uint right = arr.length - 1;

        while (left <= right) {
            uint mid = left + (right - left) / 2; // 防止溢出
            if (arr[mid] == target) {
                return int(mid);
            } else if (arr[mid] < target) {
                left = mid + 1;
            } else {
                if (mid == 0) break; // 防止 uint 下溢
                right = mid - 1;
            }
        }
        return -1;
    }
}
