// import 'package:dart_fundamentals/bank_account.dart';
import 'interest_bearing.dart';
import 'bank_account.dart';



class PremiumAccount extends BankAccount implements InterestBearing {
  final double minBalance = 10000;
  final double interestRate = 0.05;

  PremiumAccount({
    required super.accountHolderName,
    required super.accountNumber,
    required super.balance,
  });

  @override
  double withdraw(double amount) {
    if (getbalance - amount < minBalance) {
      print(
        "Min balance $minBalance limit reached. You can not withdraw balance.",
      );
    }
    balance = getbalance - amount;
    addTransaction("withdrawal amount : $amount");
    print(
      "Your withdrawal of $amount was successful. New balance : $getbalance",
    );
    return getbalance;
  }

  @override
  double deposit(double amount) {
    balance = getbalance + amount;
    addTransaction("Deposit amount: $amount");
    print(
      "Amount of $amount is deposited successfully. Your new balance : $amount",
    );
    return getbalance;
  }

  @override
  double calculateInterest() {
    return getbalance * interestRate;
  }

  @override
  void applyInterest() {
    balance = getbalance + calculateInterest();
    addTransaction("Interest of amount $calculateInterest() was applied. ");
    print("Interest applied successfully. New balance : $getbalance");
  }
}
