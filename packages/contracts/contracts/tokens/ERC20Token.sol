pragma solidity ^0.4.18;

import "./Token_v2.sol";

contract ERC20Token is Token_v2 {

    uint constant MAX_UINT = 2**256 - 1;

    function transfer(address _to, uint _value)
        public
        returns (bool) 
    {
        require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]); 
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance. See https://github.com/ethereum/EIPs/issues/717
    /// @param _from Address to transfer from.
    /// @param _to Address to transfer to.
    /// @param _value Amount to transfer.
    /// @return Success of transfer.
    function transferFrom(address _from, address _to, uint _value)
        public 
        returns (bool) 
    {
        uint allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value && balances[_to] + _value >= balances[_to]); 
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance < MAX_UINT) {
            allowed[_from][msg.sender] -= _value;
        }
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint _value) 
        public
        returns (bool)
    {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function balanceOf(address _owner)
        public
        view
        returns (uint)
    {
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) 
        public
        view
        returns (uint)
    {
        return allowed[_owner][_spender];
    }

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    uint public totalSupply;
}