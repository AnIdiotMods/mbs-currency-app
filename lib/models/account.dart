import 'enums.dart';

abstract class Account {
  Account({
    required this.id,
    required this.balance,
    required this.accountType,
    required this.createdAt,
    required this.displayName,
  });

  final String id;
  double balance;
  final AccountType accountType;
  final DateTime createdAt;
  final String displayName;

  Map<String, dynamic> toJson() => {
        'id': id,
        'balance': balance,
        'accountType': accountType.name,
        'createdAt': createdAt.toIso8601String(),
        'displayName': displayName,
      };
}
