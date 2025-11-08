abstract class BankAccount {

  //Encapsulation refers to data hiding from unnecessary use so here the use of private data via use of underscore 
  // is the perfect demonstration of how encapsulation is used in the code 
  final int _accountNumber;
  String _accountHolderName;
  double _balance;

  final List<String> _transactions = [];

  BankAccount({

    
    required String accountHolderName,
    required int accountNumber,
    required double balance,
  }) : _accountHolderName = accountHolderName,
       _accountNumber = accountNumber,
       _balance = balance;

  // transaction tracking
  void addTransaction(String transaction) {
    _transactions.add("${DateTime.now()}: $transaction");
  }

  void showTransactions() {
    if (_transactions.isEmpty) {
      print("No transactions yet.");
      return;
    }
    print("Transaction history for $_accountHolderName:");
    for (var t in _transactions) {
      print("- $t");
    }
  }

  //getters
  int get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;

  //setter is used for account holder name as it allows the name to be changed as per need
  set accountHolderName(String accountHolderName) {
    _accountHolderName = accountHolderName;
  }

  //balance should only be read-only
  double get getbalance {
    return _balance;
  }

  set balance(double balance) {
    _balance = balance;
  }

  double withdraw(double amount);
  double deposit(double amount);

  String displayInfo() {
    return "Account Holder Name: $_accountHolderName,  Account Number: $_accountNumber, Balance : $_balance";
  }
}
