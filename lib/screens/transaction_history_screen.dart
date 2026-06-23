import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key, required this.showAll});

  final bool showAll;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$');
    final date = DateFormat('MMM d, y h:mm a');

    return Scaffold(
      appBar: AppBar(title: Text(showAll ? 'Ledger' : 'Transaction History')),
      body: Consumer<AppState>(
        builder: (_, state, __) {
          final currentId = state.currentUserId;
          final txs = showAll || currentId == null
              ? state.transactions
              : state.transactions
                  .where((t) => t.fromAccount == currentId || t.toAccount == currentId)
                  .toList();

          if (txs.isEmpty) return const Center(child: Text('No transactions yet.'));

          return ListView.builder(
            itemCount: txs.length,
            itemBuilder: (_, i) {
              final tx = txs[i];
              final subtitle = [
                'Amount: ${formatter.format(tx.amount)}',
                if (tx.feeAmount > 0) 'Fee: ${formatter.format(tx.feeAmount)}',
                'Status: ${tx.status.name}',
                date.format(tx.timestamp),
              ].join(' • ');

              return ListTile(
                title: Text('${tx.fromAccount} → ${tx.toAccount} (${tx.type.name})'),
                subtitle: Text(subtitle),
              );
            },
          );
        },
      ),
    );
  }
}
