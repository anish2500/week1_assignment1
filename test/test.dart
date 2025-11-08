



import 'package:week1_assignment1/bank.dart';
import 'package:week1_assignment1/checking_account.dart';
import 'package:week1_assignment1/premium_account.dart';
import 'package:week1_assignment1/savings_account.dart';
import 'package:week1_assignment1/student_account.dart';

void main() {
  Bank bank = Bank();

  var anish = SavingsAccount(
    accountHolderName: "Anish",
    accountNumber: 1232111,
    balance: 20000,
  );
  var sagar = CheckingAccount(
    accountHolderName: "Sagar",
    accountNumber: 112232,
    balance: 30000,
  );

  var atomu = PremiumAccount(
    accountHolderName: "Atomu",
    accountNumber: 998877,
    balance: 21000,
  );

  var vinayak = StudentAccount(
    accountHolderName: "Vinayak",
    accountNumber: 8877483,
    balance: 1800,
  );

  bank.addAccount(anish);
  bank.addAccount(sagar);
  bank.addAccount(atomu);
  bank.addAccount(vinayak);

  bank.transferMoney(
    senderAccountNumber: 1232111,
    receiverAccountNumber: 8877483,
    amount: 2000,
  );

  bank.applyMonthlyInterestToAll();
  //example for abstraction is hiding implementation where with the simple function call without having to write the internal codes again 
  // it becomes convinient for the programmer to call it 
  bank.displayReport();

  vinayak.showTransactions();
  anish.showTransactions();
}
