// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FormRewards is ERC20, Ownable {
    // Reward amount per submission in wei
    uint256 public rewardAmount = 100 * 10**18; // Default 100 tokens
    
    // Track form submissions to prevent double claiming
    mapping(bytes32 => bool) public claimedSubmissions;

    event RewardClaimed(address user, uint256 amount, bytes32 submissionId);

    constructor() ERC20("FormFlow", "FORM") Ownable(msg.sender) {
        // Mint 1M tokens to contract itself for rewards
        _mint(address(this), 1_000_000 * 10**decimals());
    }

    function setRewardAmount(uint256 _rewardAmount) external onlyOwner {
        rewardAmount = _rewardAmount;
    }

    function claimReward(bytes32 submissionId) external {
        require(!claimedSubmissions[submissionId], "Already claimed");
        require(balanceOf(address(this)) >= rewardAmount, "Insufficient rewards");

        claimedSubmissions[submissionId] = true;
        _transfer(address(this), msg.sender, rewardAmount);
        
        emit RewardClaimed(msg.sender, rewardAmount, submissionId);
    }

    // Function to check if user can access form (has minimum tokens)
    function canAccessForm(address user, uint256 minTokens) external view returns (bool) {
        return balanceOf(user) >= minTokens;
    }
}