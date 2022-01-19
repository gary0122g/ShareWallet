pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract ShareWallet {

    event limitChange(address indexed _forwho, address indexed _byWhom, uint _oldAmount, uint _newAmount);
    event BalanceChange(address _who, uint _oldBalance, uint _newBalance);

    using SafeMath for uint; 
    
    address  public  owner;
    mapping(address => uint)  withdrawLimit;
    mapping(address => uint)  balance;

    constructor()  {
        owner = msg.sender;
    }

    function revceiveMoney() public payable{
        balance[owner] = balance[owner].add(msg.value);
    }

    function deposit(address _who, uint _amount) public{
        require(msg.sender == owner && _amount <= balance[msg.sender]);
        balance[msg.sender] = balance[msg.sender].sub(_amount);
        balance[_who] = balance[_who].add(_amount);
    
    }

    function increaseLimit(address _who, uint _amount) public {
        require(msg.sender == owner, "you are not the owner");
        withdrawLimit[_who] = withdrawLimit[_who].add(_amount);
        emit limitChange(_who, msg.sender, withdrawLimit[_who], withdrawLimit[_who].add(_amount));
    }

    function decreaseLimit(address _who, uint _amount) public {
        require(msg.sender == owner, "you are not the owner");
        emit limitChange(_who, msg.sender , withdrawLimit[_who], withdrawLimit[_who].sub(_amount));
        withdrawLimit[_who] = withdrawLimit[_who].sub(_amount);
    }

    function withdrawPartial(uint _amount) public {
        require(_amount <= balance[msg.sender]);
        emit BalanceChange(msg.sender, balance[msg.sender], balance[msg.sender]- _amount);
        balance[msg.sender] = balance[msg.sender].sub(_amount);
        payable(msg.sender).transfer(_amount);
    }

    function getBalance() public view returns(uint){
        return balance[msg.sender];
    }

    function getLimit() public view returns(uint){
        return withdrawLimit[msg.sender];
    }
    
    receive()  external payable{
        revceiveMoney;
    }
}

