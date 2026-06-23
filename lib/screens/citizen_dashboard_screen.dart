import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../widgets/balance_card.dart';
import 'messaging_screen.dart';
import 'nfc_payment_screen.dart';
import 'transaction_history_screen.dart';
import 'transfer_screen.dart';

class CitizenDashboardScreen extends StatelessWidget {
  const CitizenDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      final citizen = state.currentCitizen!;
      final corp = state.activeCorporateAccount;
      final displayBalance = corp?.balance ?? citizen.balance;
      final title = corp == null ? 'Personal Balance' : 'Corporate Balance';

      return Scaffold(
        appBar: AppBar(
          title: Text('Welcome, ${citizen.name}'),
          actions: [
            IconButton(
              onPressed: state.logout,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            BalanceCard(
              title: title,
              balance: displayBalance,
              partyAffiliation: citizen.partyAffiliation,
            ),
            const SizedBox(height: 16),
            if (state.ownedCorporateAccount != null)
              SwitchListTile(
                value: state.useCorporateMode,
                title: const Text('Corporate Mode'),
                subtitle: const Text('Applies 5% fee to outgoing corporate transfers'),
                onChanged: state.setCorporateMode,
              ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TransferScreen()),
                  ),
                  icon: const Icon(Icons.send),
                  label: const Text('Transfer'),
                ),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NfcPaymentScreen()),
                  ),
                  icon: const Icon(Icons.nfc),
                  label: const Text('Tap to Pay'),
                ),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MessagingScreen()),
                  ),
                  icon: const Icon(Icons.chat),
                  label: const Text('Messages'),
                ),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TransactionHistoryScreen(showAll: false)),
                  ),
                  icon: const Icon(Icons.receipt_long),
                  label: const Text('History'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
