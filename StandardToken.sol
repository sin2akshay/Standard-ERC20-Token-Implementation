pragma solidity ^0.5.2;

import "./SafeMath.sol";
import "./ERC20.sol";

///@dev Implementation of the basic standard token.
///https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
contract StandardToken is IERC20{
  using SafeMath for uint256;

  string internal name;
  string internal symbol;
  uint8 internal decimals;
  uint256 private _totalSupply;

  mapping (address => uint256) private balances;
  mapping (address => mapping (address => uint256)) private allowed;

  constructor (string memory _name, string memory _symbol, uint8 _decimals, uint256 totalSupply) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
    _totalSupply = totalSupply;
    balances[msg.sender] = totalSupply;
  }


  ///@dev Total number of tokens in existence
  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);
    balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
    balances[_to] = SafeMath.add(balances[_to], _value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  ///@dev Returns amount present in the address passed
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = SafeMath.sub(balances[_from], _value);
    balances[_to] = SafeMath.add(balances[_to], _value);
    allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) public returns(bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  ///@dev Function that checks the amount of tokens an owner has allowed to a spender
  function allowance(address _owner, address _spender) public view returns(uint256) {
    return allowed[_owner][_spender];
  }

  ///@dev Increase Allowance to a spender account
  function increaseAllowed(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  ///@dev Decrease Allowance to a spender account
  function decreaseAllowed(address _spender, uint _subtractedValue) public returns (bool) {
    uint _oldValue = allowed[msg.sender][_spender];

    if(_subtractedValue > _oldValue) {
      allowed[msg.sender][_spender] = 0;
    }
    else {
      allowed[msg.sender][_spender] = SafeMath.sub(_oldValue, _subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }
}
