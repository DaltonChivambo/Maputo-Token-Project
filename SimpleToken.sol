// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;


contract SimpleToken {

    uint256 public totalSupply; //initial value of token
    mapping(address => uint256) public balanceOf; //Guarda a informacao de quntos tokens o endereco tem //mapping QUE liga um endereco a um valor
    address public owner;


    //https://eips.ethereum.org/EIPS/eip-20
    // OPTIONAL FUNTIONS:
        // name - return the name of token
        // symbol - return symbol of the token
        // decimal - return number o decimal using by the token eg.8 (1_0000_0000)

    string public name = "Maputo Token";
    string public symbol = "MPTK";
    uint8 public decimals = 9;    


    //Permitir que outra pessoa transfira o seu token
    //Allowane e o balanceOf só guardam
    mapping(address => mapping(address => uint)) public allowance;
    //Guarda a informacao de quantos tokens uma pessoa perimite que a outra manuseia a sua conta
    


    //FUNTIONS
        // totalSupply - value of the token
        // balanceOf - returns the account balance of another account with adress _owner
        // transfer, transferFrom, approve, allowance

    //EVENTS
    event Transfer(address indexed _from, address indexed _to, uint256 _value); //to registed and indexed logs 
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);


    modifier onlyOwner{
        require(msg.sender == owner); //only owner changeOwner
        _;
    }


    constructor(){
        owner = msg.sender;
        totalSupply = 1 * 10 ** decimals;
        balanceOf[owner] = totalSupply;

    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        //require(balanceOf[msg.sender >= _value])
        require(_spender != address(0));
        allowance[msg.sender][_spender] = _value; //msg.sender aprova que spender transfira _value para alguem

        emit Approval(msg.sender, _spender, _value);

        return true;
    }


    //Ex Carlos enviar para o roberto o token que pertence ao Joao
        // ESta funcao precisa do approve do Joao (spender/gastador) a transmitir para quem quer que seja o maximo de valor
        // Permite o spender retirar tokens da tua conta multiplas vezes ate o _value
        //Essa aprovacao é registada no metodo allowance (mapping)
    function transferFrom(address _from, address _to, uint _value) public returns (bool success){
        require(allowance[_from][msg.sender] >= _value);
        require(balanceOf[_from] >= _value);
        require(_from != address(0));
        require(_to != address(0));

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value; //alterando o valor que o spender pode gastar

        emit Transfer(_from, _to, _value);

        return true;
    }

    function changeOwner(address _newOwner) public onlyOwner{
        owner = _newOwner;
    }


    //Adress 0 is initialy adress, created when smart contracts are created

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        require(_to != address(0));
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        //Emit events
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    
}
