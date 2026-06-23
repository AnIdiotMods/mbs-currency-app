import 'package:flutter/foundation.dart';
import '../models/admin_account.dart';

const double corporateFeeRate = 0.05;

class AppState extends ChangeNotifier {
  double balance;
  final AdminAccount adminAccount;

  AppState({
    this.balance = 1000.0,
    AdminAccount? adminAccount,
  }) : adminAccount = adminAccount ?? AdminAccount();

  /// Transfers [amount] out of the main balance.
  ///
  /// When [fromCorporate] is true, a 5% fee is added to the transfer cost and
  /// routed to [adminAccount] (account 000000).
  void transfer({required double amount, required bool fromCorporate}) {
    if (fromCorporate) {
      final fee = amount * corporateFeeRate;
      balance -= (amount + fee);
      adminAccount.receiveFee(fee);
    } else {
      balance -= amount;
    }
    notifyListeners();
  }
}
