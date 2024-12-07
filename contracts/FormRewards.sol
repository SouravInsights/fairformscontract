// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract FormToken is ERC20, Ownable, ReentrancyGuard {
    mapping(address => bool) public formOperators;
    mapping(address => uint256) public formRewardLimits;
    
    event FormOperatorAdded(address operator);
    event FormOperatorRemoved(address operator);
    event RewardLimitSet(address form, uint256 limit);
    event RewardSent(address to, uint256 amount, address form);

    constructor() ERC20("FormFlow", "FORM") Ownable(msg.sender) {
        _mint(msg.sender, 1000000 * 10**decimals()); // Mint 1M tokens
    }

    modifier onlyOperator() {
        require(formOperators[msg.sender], "Not a form operator");
        _;
    }

    function addFormOperator(address operator) external onlyOwner {
        formOperators[operator] = true;
        emit FormOperatorAdded(operator);
    }

    function removeFormOperator(address operator) external onlyOwner {
        formOperators[operator] = false;
        emit FormOperatorRemoved(operator);
    }

    function setFormRewardLimit(address form, uint256 limit) external onlyOwner {
        formRewardLimits[form] = limit;
        emit RewardLimitSet(form, limit);
    }

    function sendReward(address to, uint256 amount) external nonReentrant onlyOperator {
        require(amount <= formRewardLimits[msg.sender], "Reward exceeds limit");
        require(balanceOf(address(this)) >= amount, "Insufficient reward pool");
        
        _transfer(address(this), to, amount);
        emit RewardSent(to, amount, msg.sender);
    }

    // Owner can withdraw tokens from the reward pool
    function withdrawRewardPool(uint256 amount) external onlyOwner {
        require(balanceOf(address(this)) >= amount, "Insufficient balance");
        _transfer(address(this), owner(), amount);
    }
}