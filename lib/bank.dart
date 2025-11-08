// import 'package:dart_fundamentals/banking_system.dart';

import 'bank_account.dart';
import 'interest_bearing.dart';

class Bank {
  final List<BankAccount> _accounts =
      []; //for seraching the bank accounts stored in a list

  void addAccount(BankAccount account) {
    _accounts.add(account);
    print(
      "Accounts added successfully with the account name of ${account.accountHolderName}",
    );
  }

  BankAccount? findAccount(int accountNumber) {
    for (var account in _accounts) {
      if (account.accountNumber == accountNumber) {
        return account;
      }
    }

    print("Account number $accountNumber not found in the system");
    return null;
  }

  //money transfer between the accounts
  void transferMoney({
    required int senderAccountNumber,
    required int receiverAccountNumber,
    required double amount,
  }) {
    BankAccount? sender = findAccount(senderAccountNumber);
    BankAccount? receiver = findAccount(receiverAccountNumber);

    if (sender == null || receiver == null) {
      print("Transfer failed : One accounts of the two does not exist");
      return;
    }

    if (sender.getbalance < amount) {
      print(
        "Transfer failed: insufficient balance in the ${sender.accountHolderName}'s account",
      );
      return;
    }
    // if the above conditions are fulfiled the amounts are transferred

    sender.withdraw(amount);
    receiver.deposit(amount);

    print("Amount transfer of $amount was successful. ");
  }

  // now generating report of all the accounts
  void displayReport() {
    print(":::Bank Account Details:::");
    for (var account in _accounts) {
      print(account.displayInfo());
    }
  }

  void applyMonthlyInterestToAll() {
    for (var account in _accounts) {
      if (account is InterestBearing) {
        (account as InterestBearing).applyInterest();
        print(
          "Interest applied to the accounts of ${account.accountHolderName}",
        );
      }
    }
  }
}
