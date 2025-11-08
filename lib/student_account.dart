import 'bank_account.dart';

class StudentAccount extends BankAccount {
  final double _maxBalance = 5000;

  StudentAccount({
    required super.accountHolderName,
    required super.accountNumber,
    required super.balance,
  });

  @override
  double withdraw(double amount) {
    if (amount < getbalance) {
      print("Insufficient amount");
      return getbalance;
    } else {
      balance = getbalance - amount;
      addTransaction("Withdrawal amount of $amount");
      print("Withdrawal was successful. New balance is : $getbalance");
      return getbalance;
    }
  }

  @override
  double deposit(double amount) {
    if (getbalance + amount > _maxBalance) {
      print(
        "Deposit failed. Max balance limit in the $accountNumber reached. ",
      );
      return getbalance;
    } else {
      balance = getbalance + amount;
      addTransaction("Deposit of amount $amount");
      print("Deposit of amount $amount was successful.");
      return getbalance; 
    }
  }
}
