const String adminAccountNumber = '000000';

class AdminAccount {
  final String accountNumber;
  double balance;

  AdminAccount({
    this.accountNumber = adminAccountNumber,
    this.balance = 0.0,
  });

  void receiveFee(double fee) {
    balance += fee;
  }
}
