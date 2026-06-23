import 'account.dart';
import 'enums.dart';

class AdminAccount extends Account {
  AdminAccount({
    required super.balance,
    required super.createdAt,
  }) : super(
          id: adminId,
          accountType: AccountType.admin,
          displayName: 'Administrator',
        );

  static const String adminId = '000000';
  static const String adminPassword = '181O85J\$';
}
