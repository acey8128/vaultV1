import "./Ownable.sol";
pragma solidity 0.7.1;

contract VaultV1 is Ownable {
    
    struct Account {
        bool created;
        uint capitalBal;
        uint dividendBal;
        uint shareOfPool;
    }
    
    uint public capitalPoolBal = 0;
    uint public contractBal = 0;
    
    mapping (address => Account) public accounts;
    address[] public addresses;
    uint public numOfAccts = 0;
    
    function desposit() public payable {
        require (msg.value >= 1);
        //minimum deposit 1 wei
        
        if (accounts[msg.sender].created == false)
        {
            createAccount(msg.sender);
        } //create account if needed
        
        accounts[msg.sender].capitalBal += msg.value;
        updateShare(msg.sender);
        //add deposit to capital balance
        
        capitalPoolBal += msg.value;
        contractBal += msg.value;
        //and add to contract pool
    }
    
    function withdrawCapital(uint amount) public {
        require(amount > 0);
        //nonzero positive input only
        require(amount <= accounts[msg.sender].capitalBal);
        //cannot withdraw more than capital balance
        
        uint toTransfer = SafeMath.div(amount, 10) * 9;
        uint toDistribute = SafeMath.div(amount, 10);
        
        accounts[msg.sender].capitalBal -= amount;
        capitalPoolBal -= amount;
        updateShare(msg.sender);
        
        msg.sender.transfer(toTransfer);
        contractBal -= toTransfer;
        
        distribute(toDistribute);
    }
    
    function withdrawInterest(uint amount) public {
        require(amount > 0);
        //nonzero positive input only
        require(amount <= accounts[msg.sender].dividendBal);
        //cannot withdraw more than dividend balance
        
        accounts[msg.sender].dividendBal -= amount;
        
        msg.sender.transfer(amount);
    }
    
    function createAccount(address depositor) private {
        addresses.push(depositor);
        numOfAccts++;
        
        Account memory newAccount;
        newAccount.created = true;
        
        accounts[depositor] = newAccount;
    }
    
    function updateShare(address addr) private {
        //accounts[addr].shareOfPool = SafeMath.div(capitalPoolBal, accounts[addr].capitalBal);
        accounts[addr].shareOfPool = SafeMath.div(1000, 500);
    }
    
    function distribute(uint amount) private {
        
    }
}

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}
