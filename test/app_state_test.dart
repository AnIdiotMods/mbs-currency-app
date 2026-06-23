import 'package:flutter_test/flutter_test.dart';
import 'package:mbs_currency_app/models/enums.dart';
import 'package:mbs_currency_app/providers/app_state.dart';
import 'package:mbs_currency_app/services/local_database_service.dart';

void main() {
  group('Corporate fee routing', () {
    late LocalDatabaseService db;
    late AppState state;

    setUp(() {
      db = LocalDatabaseService.instance;
      db.resetWithSeedData();
      state = AppState(database: db);
      state.login(id: '100001', password: 'password123');
      state.setCorporateMode(true);
    });

    test('deducts principal + 5% fee and credits admin fee', () {
      final corporateBefore = state.activeCorporateAccount!.balance;
      final recipientBefore = state.findAnyAccount('100002')!.balance;

      final tx = state.transferFromCurrentUser(
        recipientId: '100002',
        amount: 100,
        type: TransactionType.transfer,
      );

      expect(tx.status, TransactionStatus.completed);
      expect(tx.feeAmount, 5.0);
      expect(state.activeCorporateAccount!.balance, corporateBefore - 105.0);
      expect(state.findAnyAccount('100002')!.balance, recipientBefore + 100.0);
      expect(state.admin.balance, 5.0);
    });

    test('fails when corporate cannot cover principal plus fee', () {
      state.activeCorporateAccount!.balance = 100;
      final tx = state.transferFromCurrentUser(
        recipientId: '100002',
        amount: 100,
        type: TransactionType.transfer,
      );

      expect(tx.status, TransactionStatus.failed);
      expect(state.activeCorporateAccount!.balance, 100);
      expect(state.admin.balance, 0);
      expect(tx.feeAmount, 5.0);
    });
  });
}
