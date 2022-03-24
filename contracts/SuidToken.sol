//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract SuidToken is ERC20, Ownable {

    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet private stakeholders;

    EnumerableSet.AddressSet private rewardholders;

    mapping(address => uint256) internal stakes;

    mapping(address => uint256) internal rewards;

    uint256 tokenPrice = 100;

    constructor(uint256 _supply) ERC20("Suid", "SUD") {
        _mint(msg.sender, _supply);
    }

    function buyToken(uint256 _amount) public{
        _mint(msg.sender, _amount);
    }

    function modifyTokenBuyPrice(uint256 newPrice) public onlyOwner {
        tokenPrice = newPrice;
    }

    function stake(uint256 _stake) public {
        _burn(msg.sender, _stake);
        if(stakes[msg.sender] == 0) stakeholders.add(msg.sender); 
        stakes[msg.sender]  += _stake;
    }

    function unstake(uint256 _stake) public {
        stakes[msg.sender] -=  _stake;
        if(stakes[msg.sender] == 0) stakeholders.remove(msg.sender);
        _mint(msg.sender, _stake);
    }

    function generateRewards() public onlyOwner {

        for( uint i = 0; i < stakeholders.length(); i += 1) {
            address holder = stakeholders.at(i);
            uint reward = stakes[holder] / 100;
            rewards[holder] = reward;
            rewardholders.add(holder);
        }
    }

    function resetRewards() public onlyOwner {
        for( uint i = 0; i < rewardholders.length(); i += 1) {
            address holder = rewardholders.at(i);
            rewards[holder] = 0;
        }
    }

    function withdrawReward() public {
        uint reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        _mint(msg.sender, reward);

    }


}