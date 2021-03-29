pragma solidity ^0.4.18;
import './SafeMath.sol';


/**
    QRC20Token Standard Token implementation
*/
contract QRC20Token is SafeMath {
    string public constant standard = 'Token 0.1';
    uint8 public constant decimals = 8; // it's recommended to set decimals to 8 in QTUM

    // you need change the following three values
    string public constant name = 'QRC TEST';
    string public constant symbol = 'QTC';
    //Default assumes totalSupply can't be over max (2^256 - 1).
    //you need multiply 10^decimals by your real total supply.
    uint256 public totalSupply = 10**9 * 10**uint256(decimals);

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function QRC20Token() public {
        balanceOf[msg.sender] = totalSupply;
        Transfer(0x0, msg.sender, totalSupply);
    }

    // validates an address - currently only checks that it isn't null
    modifier validAddress(address _address) {
        require(_address != 0x0);
        _;
    }

    function transfer(address _to, uint256 _value)
    public
    validAddress(_to)
    returns (bool success)
    {
        balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value)
    public
    validAddress(_from)
    validAddress(_to)
    returns (bool success)
    {
        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
        balanceOf[_from] = safeSub(balanceOf[_from], _value);
        balanceOf[_to] = safeAdd(balanceOf[_to], _value);
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value)
    public
    validAddress(_spender)
    returns (bool success)
    {
        allowance[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    // disable pay QTUM to this contract
    function () public payable {
        revert();
    }
}
