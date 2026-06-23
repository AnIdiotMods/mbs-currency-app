import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import 'transaction_history_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _accountSearchController = TextEditingController();

  @override
  void dispose() {
    _accountSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrator Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TransactionHistoryScreen(showAll: true)),
            ),
          ),
          IconButton(onPressed: context.read<AppState>().logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Consumer<AppState>(
        builder: (_, state, __) {
          final q = _accountSearchController.text.toLowerCase();
          final accounts = [...state.citizens, ...state.corporates]
              .where((a) => a.id.toLowerCase().contains(q) || a.displayName.toLowerCase().contains(q))
              .toList();

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: const Text('Accumulated Corporate Fee Balance'),
                  subtitle: Text(money.format(state.admin.balance), style: const TextStyle(fontSize: 20)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _accountSearchController,
                  decoration: const InputDecoration(labelText: 'Search accounts', prefixIcon: Icon(Icons.search)),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (_, i) {
                    final account = accounts[i];
                    return ListTile(
                      title: Text(account.displayName),
                      subtitle: Text('${account.id} • ${account.accountType.name} • ${money.format(account.balance)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showAdjustDialog(context, account.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showAdjustDialog(BuildContext context, String accountId) async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Adjust $accountId balance'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          decoration: const InputDecoration(labelText: 'Delta (e.g. 50 or -20)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final delta = double.tryParse(controller.text);
              if (delta == null) return;
              final tx = context.read<AppState>().adminAdjustBalance(accountId: accountId, delta: delta);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Adjustment ${tx.status.name}: ${tx.failureReason ?? 'success'}')),
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
