/*
    This exercise has been updated to use Solidity version 0.5
    Breaking changes from 0.4 to 0.5 can be found here: 
    https://solidity.readthedocs.io/en/v0.5.0/050-breaking-changes.html
*/

pragma solidity ^0.5.0;

contract SimpleBank {

    //
    // State variables
    //
    
    /* Fill in the keyword. Hint: We want to protect our users balance from other contracts*/
    mapping (address => uint) private balances;
    
    /* Fill in the keyword. We want to create a getter function and allow contracts to be able to see if a user is enrolled.  */
    mapping (address => bool) public enrolled;

    /* Let's make sure everyone knows who owns the bank. Use the appropriate keyword for this*/
    address public owner;
    
    //
    // Events - publicize actions to external listeners
    //
    
    /* Add an argument for this event, an accountAddress */
    event LogEnrolled(address accountAddress);

    /* Add 2 arguments for this event, an accountAddress and an amount */
    event LogDepositMade(address accountAddress, uint amount);

    /* Create an event called LogWithdrawal */
    /* Add 3 arguments for this event, an accountAddress, withdrawAmount and a newBalance */
    event LogWithdrawl(address accountAddress, uint withdrawAmount, uint newBalance);
    //
    // Functions
    //

    /* Use the appropriate global variable to get the sender of the transaction */
    constructor() public {
        /* Set the owner to the creator of this contract */
        owner = msg.sender;
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function() external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    // A SPECIAL KEYWORD prevents function from editing state variables;
    // allows function to run locally/off blockchain
    function getBalance() public returns (uint) {
        /* Get the balance of the sender of this transaction */
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public returns (bool){
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return true;
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    // Add the appropriate keyword so that this function can receive ether
    // Use the appropriate global variables to get the transaction sender and value
    // Emit the appropriate event    
    // Users should be enrolled before they can make deposits
    function deposit() public payable returns (uint) {
        /* Add the amount to the user's balance, call the event associated with a deposit,
          then return the balance of the user */
          require(enrolled[msg.sender] == true, "Sender should be enrolled.");
          balances[msg.sender] += msg.value;
          emit LogDepositMade(msg.sender, msg.value);
          return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    // Emit the appropriate event    
    function withdraw(uint withdrawAmount) public returns (uint) {
        /* If the sender's balance is at least the amount they want to withdraw,
           Subtract the amount from the sender's balance, and try to send that amount of ether
           to the user attempting to withdraw. 
           return the user's balance.*/
           require(balances[msg.sender] >= withdrawAmount, "Not enough funds.");
           balances[msg.sender] -= withdrawAmount;
           msg.sender.transfer(withdrawAmount);
           emit LogWithdrawl(msg.sender, withdrawAmount, balances[msg.sender]);
           return balances[msg.sender];
    }

}
