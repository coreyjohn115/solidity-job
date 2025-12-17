// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Voting
 * @dev 实现一个投票合约
 */
contract Voting {
    struct VoteData {
        uint256 voteCount;
        mapping(address => bool) voted;
    }

    mapping(address => VoteData) public votesReceived;
    address[] candidateList;
    address owner;

    constructor(address[] memory _candidateList) {
        candidateList = _candidateList;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function vote(address voter) public {
        require(voter == address(0), "Invalid voter");
        require(!votesReceived[voter].voted[msg.sender], "Already voted");

        votesReceived[voter].voteCount++;
        votesReceived[voter].voted[msg.sender] = true;
    }

    function getVotes(address _dstAddr) public view returns (uint) {
        return votesReceived[_dstAddr].voteCount;
    }

    function resetVotes() public onlyOwner {
        for (uint256 index = 0; index < candidateList.length; index++) {
            delete votesReceived[candidateList[index]];
        }
    }
}
