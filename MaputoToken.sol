// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

contract MaputoToken {

    string public name = "Maputo Token";
    string public symbol = "MPT";
    uint public totalSupply = 10**9;

    mapping(address => uint256) public balances;
    mapping(address => bool) public minted;
    mapping(address => mapping(address => uint)) public allowance;

    address public owner;
    address public philanthropicAddress;
    uint public philanthropicFee = 1; // (1/10000) 0.01%
    
    event Transfer(address indexed _from, address indexed _to, uint256 _amount); 
    event Approval(address indexed _owner, address indexed _spender, uint256 _amount);

    constructor(){
        owner = msg.sender;
        balances[owner] = totalSupply;
    }

    modifier onlyOwner{
        require(msg.sender == owner); //only owner changeOwner
        _;
    }

    modifier canMint() {
        require(!minted[msg.sender], "You have already minted tokens");
        _;
    }

    function mint() public canMint {
        balances[msg.sender] += 10000;
        minted[msg.sender] = true;
    }

    function setPhilanthropicAddress(address _newAddress) public onlyOwner{
        philanthropicAddress = _newAddress;
    }

    function approve(address _spender, uint256 _amount) public returns (bool success) {
        require(balances[msg.sender] >= _amount);
        require(_spender != address(0));
        allowance[msg.sender][_spender] = _amount; 

        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint _amount) public returns (bool success){
        require(allowance[_from][msg.sender] >= _amount);
        require(balances[_from] >= _amount);
        require(_from != address(0));
        require(_to != address(0));

        balances[_from] -= _amount;
        balances[_to] += _amount;

        uint philanthropicAmount = (_amount * philanthropicFee) / 10000;
        balances[_from] -= philanthropicAmount;
        balances[philanthropicAddress] += philanthropicAmount;
        allowance[_from][msg.sender] -= _amount;

        emit Transfer(_from, _to, _amount);
        return true;
    }

    function transfer(address _to, uint256 _amount) public returns (bool success) {
        require(balances[msg.sender] >= _amount);
        require(_to != address(0));
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        uint philanthropicAmount = (_amount * philanthropicFee) / 10000;
        balances[msg.sender] -= philanthropicAmount;
        balances[philanthropicAddress] += philanthropicAmount;

        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

}
