

import 'bank_account.dart';
import 'interest_bearing.dart';


// Here is the example of inheritance where the Savings Account possess or inherits the similar properties of its parent class BankAccount
// so there is no need to write extra lines of codes for the convinience of the programmer 
class SavingsAccount extends  BankAccount implements InterestBearing {
  final double minBalance = 500.0;
  final double interestRate = 0.02;
  final int maxWithdrawalLimit = 3;

  int withdrawThisMonth = 0; //setting the base withdraw as 0 for default

  SavingsAccount({
    required super.accountHolderName,
    required super.accountNumber,
    required super.balance,
  });

  @override
  //polymorphism means many forms or method overriding 
  // where the double withdraw is defined in parents class but it follows method overriding by using different algorithms in the run time execution of the method 
  
  double withdraw(double amount) {
    if (withdrawThisMonth >= maxWithdrawalLimit) {
      print("You have reached a withdraw limit");
      return getbalance;
    }
    if (getbalance - amount < minBalance) {
      print("Withdraw failed : min balance of \$500 reached");
    }

    balance = getbalance - amount;

    withdrawThisMonth++;
    print("Withdraw successful. The remaining balance is : $getbalance");

    return getbalance;
  }

  @override
  double deposit(double amount) {
    balance = getbalance + amount;
    addTransaction("Deposit made : $amount");
    print(
      "The $amount is successfully deposited. Your current balance is $getbalance",
    );
    return getbalance; // returns current balance after deposit
  }

  @override
  //calculatin the interest
  double calculateInterest() {
    return getbalance * interestRate;
  }

  @override
  //applying the interest
  void applyInterest() {
    double interest = calculateInterest();
    balance = getbalance + interest;

    addTransaction("The interest applied is : ${calculateInterest()}");
    print(
      "The $interest of interest is applied to the account of $accountHolderName new balance : $getbalance",
    );
  }
}
