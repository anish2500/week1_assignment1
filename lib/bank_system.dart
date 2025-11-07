import 'dart:math';

// Transaction class to track all account activities
class Transaction {
  final DateTime timestamp;
  final String type;
  final double amount;
  final double balanceAfter;
  final String description;

  Transaction({
    required this.timestamp,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.description,
  });

  @override
  String toString() {
    return '${timestamp.toString()} | $type | \$${amount.toStringAsFixed(2)} | Balance: \$${balanceAfter.toStringAsFixed(2)} | $description';
  }
}

// Interface for interest-bearing accounts
abstract class InterestBearing {
  void calculateInterest();
}

// Abstract base class for all bank accounts
abstract class BankAccount {
  final String _accountNumber;
  String _accountHolderName;
  double _balance;
  final List<Transaction> _transactionHistory = []; // Encapsulated transaction history

  BankAccount(this._accountHolderName, this._balance)
      : _accountNumber = generateAccountNumber() {
    // Record initial deposit as first transaction
    _addTransaction(
      'DEPOSIT',
      _balance,
      _balance,
      'Account opened with initial deposit',
    );
  }

  static String generateAccountNumber() {
    final random = Random();
    return List.generate(10, (index) => random.nextInt(10)).join();
  }

  // Getters
  String get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  double get balance => _balance;

  // Get transaction history (read-only)
  List<Transaction> get transactionHistory => List.unmodifiable(_transactionHistory);

  set accountHolderName(String newName) {
    if (newName.isNotEmpty) {
      _accountHolderName = newName;
    } else {
      print('Error: Account holder name cannot be empty.');
    }
  }

  // Protected method to add transactions
  void _addTransaction(String type, double amount, double balanceAfter, String description) {
    _transactionHistory.add(Transaction(
      timestamp: DateTime.now(),
      type: type,
      amount: amount,
      balanceAfter: balanceAfter,
      description: description,
    ));
  }

  // Abstract method for withdrawal (polymorphism)
  void withdraw(double amount);

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      _addTransaction('DEPOSIT', amount, _balance, 'Cash deposit');
      print('Deposit successful. New balance: \$${_balance.toStringAsFixed(2)}');
    } else {
      print('Error: Deposit amount must be positive.');
    }
  }

  void displayAccountInfo() {
    print('Account Details:');
    print('Account Type: ${runtimeType.toString()}');
    print('Account No: $_accountNumber');
    print('Holder Name: $_accountHolderName');
    print('Current Balance: \$${_balance.toStringAsFixed(2)}');
  }

  // New method to display transaction history
  void displayTransactionHistory() {
    print('\n=== Transaction History for $_accountHolderName ===');
    if (_transactionHistory.isEmpty) {
      print('No transactions found.');
      return;
    }
    
    for (var transaction in _transactionHistory) {
      print(transaction);
    }
    print('Total Transactions: ${_transactionHistory.length}');
  }
}

// Account implementations with inheritance

class SavingsAccount extends BankAccount implements InterestBearing {
  static const double _minimumBalance = 500.00;
  static const double _interestRate = 0.02;
  static const int _withdrawalLimit = 3;
  int _monthlyWithdrawals = 0;

  SavingsAccount(String name, double initialBalance) : super(name, initialBalance);

  @override
  void withdraw(double amount) {
    try {
      if (amount <= 0) {
        throw Exception('Withdrawal amount must be positive.');
      }
      if (balance - amount < _minimumBalance) {
        throw Exception(
            'Withdrawal denied. Minimum balance of \$${_minimumBalance.toStringAsFixed(2)} must be maintained.');
      }
      if (_monthlyWithdrawals >= _withdrawalLimit) {
        throw Exception(
            'Withdrawal denied. Monthly limit of $_withdrawalLimit transactions exceeded.');
      }

      _balance -= amount;
      _monthlyWithdrawals++;
      _addTransaction('WITHDRAWAL', amount, _balance, 'Cash withdrawal');
      
      print('Withdrawal of \$${amount.toStringAsFixed(2)} successful. Remaining balance: \$${_balance.toStringAsFixed(2)}');
      print('Monthly withdrawals remaining: ${_withdrawalLimit - _monthlyWithdrawals}');
    } catch (e) {
      print('Error: Failed to withdraw from Savings Account: ${e.toString()}');
    }
  }

  @override
  void calculateInterest() {
    if (balance >= _minimumBalance) {
      final interest = balance * _interestRate;
      _balance += interest;
      _addTransaction('INTEREST', interest, _balance, 'Monthly interest applied');
      
      print('Interest of \$${interest.toStringAsFixed(2)} applied. New balance: \$${_balance.toStringAsFixed(2)}');
    } else {
      print('No interest applied. Balance is below minimum requirement.');
    }
    _monthlyWithdrawals = 0;
    print('Monthly withdrawal count has been reset.');
  }

  @override
  void displayAccountInfo() {
    super.displayAccountInfo();
    print('Minimum Balance: \$${_minimumBalance.toStringAsFixed(2)}');
    print('Interest Rate: ${(_interestRate * 100).toStringAsFixed(0)}%');
    print('Withdrawals this month: $_monthlyWithdrawals/$_withdrawalLimit');
  }
}

class CheckingAccount extends BankAccount {
  static const double _overdraftFee = 35.00;

  CheckingAccount(String name, double initialBalance) : super(name, initialBalance);

  @override
  void withdraw(double amount) {
    try {
      if (amount <= 0) {
        throw Exception('Withdrawal amount must be positive.');
      }

      double oldBalance = _balance;
      _balance -= amount;

      if (_balance < 0) {
        _balance -= _overdraftFee;
        _addTransaction('OVERDRAFT_FEE', _overdraftFee, _balance, 'Overdraft penalty');
        print('Overdraft warning! \$${_overdraftFee.toStringAsFixed(2)} fee applied.');
      }

      _addTransaction('WITHDRAWAL', amount, _balance, 'Cash withdrawal');
      print('Withdrawal of \$${amount.toStringAsFixed(2)} successful. New balance: \$${_balance.toStringAsFixed(2)}');
    } catch (e) {
      print('Error: Failed to withdraw from Checking Account: ${e.toString()}');
    }
  }

  @override
  void displayAccountInfo() {
    super.displayAccountInfo();
    print('Overdraft Fee: \$${_overdraftFee.toStringAsFixed(2)} (if balance goes below \$0)');
  }
}

class PremiumAccount extends BankAccount implements InterestBearing {
  static const double _minimumBalance = 10000.00;
  static const double _interestRate = 0.05;

  PremiumAccount(String name, double initialBalance) : super(name, initialBalance);

  @override
  void withdraw(double amount) {
    try {
      if (amount <= 0) {
        throw Exception('Withdrawal amount must be positive.');
      }
      if (balance - amount < 0) {
        throw Exception('Insufficient funds. Withdrawal would result in a negative balance.');
      }

      _balance -= amount;
      _addTransaction('WITHDRAWAL', amount, _balance, 'Cash withdrawal');
      print('Withdrawal of \$${amount.toStringAsFixed(2)} successful. New balance: \$${_balance.toStringAsFixed(2)}');
    } catch (e) {
      print('Error: Failed to withdraw from Premium Account: ${e.toString()}');
    }
  }

  @override
  void calculateInterest() {
    if (balance >= _minimumBalance) {
      final interest = balance * _interestRate;
      _balance += interest;
      _addTransaction('INTEREST', interest, _balance, 'Monthly interest applied');
      
      print('Interest of \$${interest.toStringAsFixed(2)} applied. New balance: \$${_balance.toStringAsFixed(2)}');
    } else {
      print('No interest applied. Balance is below minimum requirement of \$${_minimumBalance.toStringAsFixed(2)}.');
    }
  }

  @override
  void displayAccountInfo() {
    super.displayAccountInfo();
    print('Minimum Balance: \$${_minimumBalance.toStringAsFixed(2)}');
    print('Interest Rate: ${(_interestRate * 100).toStringAsFixed(0)}%');
    print('Withdrawal Policy: Unlimited free withdrawals');
  }
}

// NEW: Student Account Class with no fees and maximum balance limit
class StudentAccount extends BankAccount implements InterestBearing {
  static const double _maximumBalance = 5000.00;
  static const double _interestRate = 0.01; // 1% interest for students
  static const int _withdrawalLimit = 10; // More withdrawals for students

  StudentAccount(String name, double initialBalance) : super(name, initialBalance) {
    if (initialBalance > _maximumBalance) {
      throw Exception('Student account cannot exceed maximum balance of \$$_maximumBalance');
    }
  }

  @override
  void withdraw(double amount) {
    try {
      if (amount <= 0) {
        throw Exception('Withdrawal amount must be positive.');
      }
      if (balance - amount < 0) {
        throw Exception('Insufficient funds. Withdrawal would result in a negative balance.');
      }

      _balance -= amount;
      _addTransaction('WITHDRAWAL', amount, _balance, 'Cash withdrawal - Student Account');
      
      print('Withdrawal of \$${amount.toStringAsFixed(2)} successful. Remaining balance: \$${_balance.toStringAsFixed(2)}');
      print('No fees applied - Student benefit!');
    } catch (e) {
      print('Error: Failed to withdraw from Student Account: ${e.toString()}');
    }
  }

  @override
  void deposit(double amount) {
    if (amount > 0) {
      if (_balance + amount > _maximumBalance) {
        print('Error: Deposit would exceed maximum student account balance of \$$_maximumBalance');
        return;
      }
      _balance += amount;
      _addTransaction('DEPOSIT', amount, _balance, 'Cash deposit - Student Account');
      
      print('Deposit successful. New balance: \$${_balance.toStringAsFixed(2)}');
      print('No fees applied - Student benefit!');
    } else {
      print('Error: Deposit amount must be positive.');
    }
  }

  @override
  void calculateInterest() {
    // Students get interest regardless of balance, but only up to maximum
    final interest = balance * _interestRate;
    
    if (_balance + interest <= _maximumBalance) {
      _balance += interest;
      _addTransaction('INTEREST', interest, _balance, 'Monthly interest applied - Student Account');
      
      print('Student interest of \$${interest.toStringAsFixed(2)} applied. New balance: \$${_balance.toStringAsFixed(2)}');
    } else {
      // If interest would exceed maximum, only add up to maximum
      double allowedInterest = _maximumBalance - _balance;
      if (allowedInterest > 0) {
        _balance += allowedInterest;
        _addTransaction('INTEREST', allowedInterest, _balance, 'Monthly interest (capped) - Student Account');
        
        print('Student interest of \$${allowedInterest.toStringAsFixed(2)} applied (capped at maximum balance). New balance: \$${_balance.toStringAsFixed(2)}');
      } else {
        print('Account at maximum balance. No interest applied.');
      }
    }
  }

  @override
  void displayAccountInfo() {
    super.displayAccountInfo();
    print('Account Type: Student Account');
    print('Maximum Balance: \$${_maximumBalance.toStringAsFixed(2)}');
    print('Interest Rate: ${(_interestRate * 100).toStringAsFixed(0)}%');
    print('Withdrawal Policy: No fees, unlimited withdrawals');
    print('Special Features: Zero maintenance fees');
  }
}

// Bank management class
class Bank {
  final Map<String, BankAccount> _accounts = {};

  BankAccount createAccount(String name, double initialBalance, String type) {
    BankAccount newAccount;
    switch (type.toLowerCase()) {
      case 'savings':
        newAccount = SavingsAccount(name, initialBalance);
        break;
      case 'checking':
        newAccount = CheckingAccount(name, initialBalance);
        break;
      case 'premium':
        newAccount = PremiumAccount(name, initialBalance);
        break;
      case 'student': // NEW: Student account type
        newAccount = StudentAccount(name, initialBalance);
        break;
      default:
        throw Exception('Invalid account type specified: $type');
    }
    _accounts[newAccount.accountNumber] = newAccount;
    print('\n[SYSTEM] Successfully created new ${type} account: ${newAccount.accountNumber}');
    return newAccount;
  }

  BankAccount? findAccount(String accountNumber) {
    final account = _accounts[accountNumber];
    if (account == null) {
      print('\n[SYSTEM] Error: Account number $accountNumber not found.');
    }
    return account;
  }

  void applyMonthlyInterest() {
    print('\n========================================');
    print('APPLYING MONTHLY INTEREST TO ALL ACCOUNTS');
    print('========================================');
    
    int interestAccounts = 0;
    for (var account in _accounts.values) {
      if (account is InterestBearing) {
        print('\nProcessing account: ${account.accountNumber} (${account.accountHolderName})');
        (account as InterestBearing).calculateInterest();
        interestAccounts++;
      }
    }
    
    if (interestAccounts == 0) {
      print('No interest-bearing accounts found.');
    } else {
      print('\nTotal interest applied to: $interestAccounts accounts');
    }
  }

  void generateAccountsReport() {
    print('\n\n');
    print('BANK ACCOUNTS REPORT (${_accounts.length} Total Accounts)');
    print('\n');
    if (_accounts.isEmpty) {
      print('No accounts currently registered.');
      return;
    }
    for (var account in _accounts.values) {
      account.displayAccountInfo();
      print('----');
    }
  }
}

// Main execution with new features demonstration
void main() {
  print('Dart Banking System: OOP Challenge Demo');
  print('Extended with Student Accounts & Transaction History');
  print('\n');

  final myBank = Bank();

  // Create accounts including new Student Account
  final savings1 = myBank.createAccount('Anish Tamang', 1200.00, 'savings');
  final checking1 = myBank.createAccount('Atomu Gyawali', 300.00, 'checking');
  final premium1 = myBank.createAccount('Sagar Lama', 15000.00, 'premium');
  final student1 = myBank.createAccount('John Student', 800.00, 'student');

  print('\n\n');
  print('OPERATION DEMONSTRATION WITH NEW FEATURES');
  print('\n');

  // Test existing accounts
  print(' Savings Account Test (Anish)');
  savings1.deposit(100.00);
  savings1.withdraw(50.00);
  savings1.withdraw(50.00);

  print('\n Checking Account Test (Atomu)');
  checking1.withdraw(200.00);
  checking1.withdraw(400.00); // This will trigger overdraft

  print('\n Premium Account Test (Sagar)');
  premium1.withdraw(5000.00);
  premium1.deposit(2000.00);

  // NEW: Test Student Account
  print('\n Student Account Test (John)');
  student1.deposit(200.00);
  student1.withdraw(150.00);
  student1.deposit(4500.00); // This should be rejected (exceeds maximum)

  // Apply monthly interest to all interest-bearing accounts
  myBank.applyMonthlyInterest();

  // Generate comprehensive report
  myBank.generateAccountsReport();

  // NEW: Display transaction histories
  print('\n\n');
  print('TRANSACTION HISTORY DEMONSTRATION');
  print('\n');
  
  savings1.displayTransactionHistory();
  print('\n');
  student1.displayTransactionHistory();

  // Account search test
  print('\n\n');
  print('ACCOUNT SEARCH TEST');
  print('\n');
  
  final foundAccount = myBank.findAccount(savings1.accountNumber);
  if (foundAccount != null) {
    print('Successfully found account for ${foundAccount.accountHolderName}.');
  }

  myBank.findAccount('9999999999'); // Non-existent account
}