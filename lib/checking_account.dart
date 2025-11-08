import 'bank_account.dart';

class CheckingAccount extends BankAccount {
  final double overdraftLimit = 35.00;

  CheckingAccount({
    required super.accountNumber,
    required super.accountHolderName,
    required super.balance,
  });

  @override
  double withdraw(double amount) {
    balance = getbalance - amount;

    if (getbalance < 0) {
      balance = getbalance - overdraftLimit;
      print(
        "Overdraft limit reached Fee of $overdraftLimit applied. New balance : $getbalance",
      );
    } else {
      print("Withdraw successful. Your new balance is : $getbalance");
    }

    addTransaction(" Withdraw amount : $amount");
    return getbalance;
  }

  @override
  double deposit(double amount) {
    balance = getbalance + amount;
    addTransaction("Deposit amount : $amount");
    print(
      "Sum of $amount was successfully deposited. New balance is : $getbalance",
    );
    return getbalance; 
  }
}
