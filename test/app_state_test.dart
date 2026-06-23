import 'package:flutter_test/flutter_test.dart';
import 'package:mbs_currency_app/providers/app_state.dart';
import 'package:mbs_currency_app/models/admin_account.dart';

void main() {
  group('AppState transfer', () {
    test('non-corporate transfer deducts exact amount', () {
      final state = AppState(balance: 500.0);
      state.transfer(amount: 100, fromCorporate: false);
      expect(state.balance, closeTo(400.0, 0.001));
      expect(state.adminAccount.balance, closeTo(0.0, 0.001));
    });

    test('corporate transfer deducts principal plus 5% fee', () {
      final state = AppState(balance: 500.0);
      state.transfer(amount: 100, fromCorporate: true);
      // 100 principal + 5 fee = 105 deducted
      expect(state.balance, closeTo(395.0, 0.001));
      expect(state.adminAccount.balance, closeTo(5.0, 0.001));
    });

    test('corporate fee routes to admin account 000000', () {
      final admin = AdminAccount();
      final state = AppState(balance: 1000.0, adminAccount: admin);
      state.transfer(amount: 200, fromCorporate: true);
      expect(admin.accountNumber, '000000');
      expect(admin.balance, closeTo(10.0, 0.001));
    });
  });
}
