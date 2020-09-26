import "./Ownable.sol";
pragma solidity 0.7.1;

contract VaultV1 is Ownable{
    
    struct Account {
        bool created;
        uint totalDeposits;
        uint currentBalance;
    }
    
    uint public contractBalance = 0;
    
    mapping (address => Account) public accounts;
    address[] public addresses;
    uint public numOfAccts = 0;
    
    function desposit() public payable {
        if (accounts[msg.sender].created == false)
        {
            createAccount(msg.sender);
        }
        
        accounts[msg.sender].totalDeposits += msg.value;
        accounts[msg.sender].currentBalance += msg.value;
        
        contractBalance += msg.value;
    }
    
    function withdraw() public {
        
    }
    
    function createAccount(address depositor) private {
        addresses.push(depositor);
        numOfAccts++;
        
        Account memory newAccount;
        newAccount.totalDeposits = 0;
        newAccount.currentBalance = 0;
        newAccount.created = true;
        
        accounts[depositor] = newAccount;
    }
    
    function updateBalance() private {
        
    }
}
