// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MaputoToken {
    string public name = "Maputo Token";
    string public symbol = "MPT";
    uint8 public decimals = 18;
    uint public totalSupply = 10**9 * 10**uint(decimals);

    mapping(address => uint) public balances;
    mapping(address => bool) public minted;

    address public philanthropicAddress;
    uint public philanthropicFee = 1; // (1/10000) 0.01%

    constructor() {
        balances[address(0)] = totalSupply;
    }

    function setPhilanthropicAddress(address _address) public {
        require(msg.sender == address(0), "Only the deployer can set the philanthropic address");
        philanthropicAddress = _address;
    }

    function mint() public {
        require(!minted[msg.sender], "Already minted");
        require(balances[address(0)] >= 10000 * 10**uint(decimals), "Not enough tokens to mint");
        balances[msg.sender] += 10000 * 10**uint(decimals);
        balances[address(0)] -= 10000 * 10**uint(decimals);
        minted[msg.sender] = true;
    }

    function transfer(address to, uint amount) public {
        require(balances[msg.sender] >= amount, "Not enough balance");
        require(to != address(0), "Invalid recipient address");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        uint philanthropicAmount = (amount * philanthropicFee) / 10000;
        balances[philanthropicAddress] += philanthropicAmount;
    }
}
