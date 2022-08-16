// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Tether {
    string public name = "Tether Token" ;
    string public symbol = "TEH" ;
    uint public amount = 1000000000000000000000000;
    uint public decimal = 18;


event Transfer (
    address indexed _from,
    address indexed _to,
    uint value
);

event Approve (
    address _owner,
    address _spender,
    uint _value
);

mapping(address => uint) public balanceOf;
mapping (address => mapping(address => uint)) public allowance;
mapping (address =>  uint) public allowance_debt;

constructor () {
    balanceOf[msg.sender] = amount;
}

function transfer(address _to, uint _value) public returns (bool success) {
    require(balanceOf[msg.sender]>= _value);
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
}

function approval (address _to, uint _value) public returns (bool success) {
    allowance[msg.sender][_to] = _value;
    return success;
}

function approval_debt(address _to, uint _value) public returns (bool success) {
    allowance_debt[_to] = _value;
    return success;
}

function transferFrom (address _from, address _to, uint _value) public returns (bool success) {
    require(balanceOf[_from] >= _value);
    require(allowance[_from][msg.sender] >= _value);
    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    emit Transfer(_from, _to, _value);
    return success;
}

function transferFrom_debt(address _from, address _to, uint _value) public returns (bool success) {
    require(allowance_debt[_to] >= _value);
    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    emit Transfer(_from, _to, _value);
    return success;
}

}