import 'enums.dart';

class AppTransaction {
  AppTransaction({
    required this.id,
    required this.fromAccount,
    required this.toAccount,
    required this.amount,
    required this.timestamp,
    required this.type,
    required this.status,
    this.feeAmount = 0,
    this.failureReason,
  });

  final String id;
  final String fromAccount;
  final String toAccount;
  final double amount;
  final DateTime timestamp;
  final TransactionType type;
  final TransactionStatus status;
  final double feeAmount;
  final String? failureReason;

  Map<String, dynamic> toJson() => {
        'id': id,
        'fromAccount': fromAccount,
        'toAccount': toAccount,
        'amount': amount,
        'timestamp': timestamp.toIso8601String(),
        'type': type.name,
        'status': status.name,
        'feeAmount': feeAmount,
        'failureReason': failureReason,
      };
}
