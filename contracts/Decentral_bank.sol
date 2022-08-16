// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Tether.sol";
import "./Reward.sol";

contract Decentral_bank {
    string public name = "DecentralBank";
    address public owner;
    Tether public tether;
    Reward public reward;

    address[] public stakers;

    constructor(Reward _reward, Tether _tether)  {
        reward = _reward;
        tether = _tether;
        owner = msg.sender;
    }

    mapping (address => uint) public stakingBalance;
    mapping (address => bool) public hasStaking;
    mapping (address => bool) public isStaked;  
    mapping (address => uint) public stake_reward;
    mapping (address => uint) public debt;
    mapping (address => uint) public debt_divident;

    function Deposit (uint _amount) public {
        require(_amount > 0, 'amount cannot be less than zero');
        tether.transferFrom(msg.sender, address(this), _amount);
        stakingBalance[msg.sender] += _amount;
        uint divident = _amount / 10;
        stake_reward[msg.sender] += divident;
        reward.transfer(msg.sender, divident);

        if(!hasStaking[msg.sender]) {
            stakers.push(msg.sender);
        }

        hasStaking[msg.sender] = true;
        isStaked[msg.sender] = true;
    }

    function issuedToken () public {
        require(msg.sender == owner);
        for (uint i = 0; i < stakers.length; i++) {
            address account = stakers[i];
            uint balance = stakingBalance[account] / 10;
            require(balance > 0);
            reward.transfer(account, balance);
        }
    }

    function unstakeToken (uint _amount) public {
        require(stakingBalance[msg.sender] >= _amount);
        stakingBalance[msg.sender] -= _amount;
        tether.transfer(msg.sender, _amount);
        if (stakingBalance[msg.sender] == 0){
             isStaked[msg.sender] = false;
             hasStaking[msg.sender] = false;
        }

    }

    function apply_debt (uint _amount) public {
        require(_amount > 0, 'amount cannot be less than zero');
        tether.transferFrom_debt(address(this), msg.sender, _amount);
        uint pay = _amount/5;
        debt_divident[msg.sender] += pay;
        debt[msg.sender] += _amount;
    }
}