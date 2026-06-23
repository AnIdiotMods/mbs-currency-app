import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';

import '../models/enums.dart';
import '../providers/app_state.dart';

class NfcPaymentScreen extends StatefulWidget {
  const NfcPaymentScreen({super.key});

  @override
  State<NfcPaymentScreen> createState() => _NfcPaymentScreenState();
}

class _NfcPaymentScreenState extends State<NfcPaymentScreen> {
  final _fallbackRecipient = TextEditingController();
  final _amountController = TextEditingController();
  String? _capturedId;

  @override
  void dispose() {
    _fallbackRecipient.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _startNfcRead() async {
    final available = await NfcManager.instance.isAvailable();
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('NFC unavailable. Use manual ID.')));
      return;
    }

    await NfcManager.instance.startSession(onDiscovered: (tag) async {
      final idRaw = tag.data['nfca']?['identifier']?.toString();
      if (!mounted) return;
      setState(() => _capturedId = idRaw);
      await NfcManager.instance.stopSession();
    });
  }

  void _sendPayment() {
    final recipient = (_capturedId ?? _fallbackRecipient.text).trim();
    final amount = double.tryParse(_amountController.text);

    if (recipient.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recipient and amount are required.')));
      return;
    }

    final tx = context.read<AppState>().transferFromCurrentUser(
          recipientId: recipient,
          amount: amount,
          type: TransactionType.payment,
        );

    final success = tx.status == TransactionStatus.completed;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'NFC payment complete.' : 'Payment failed: ${tx.failureReason}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tap to Pay (NFC)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: _startNfcRead,
            icon: const Icon(Icons.nfc),
            label: const Text('Read Recipient NFC Tag'),
          ),
          const SizedBox(height: 12),
          Text('Captured NFC ID: ${_capturedId ?? 'None'}'),
          const SizedBox(height: 12),
          TextField(
            controller: _fallbackRecipient,
            decoration: const InputDecoration(labelText: 'Manual Recipient ID (fallback)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Amount'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _sendPayment, child: const Text('Send Payment')),
        ],
      ),
    );
  }
}
