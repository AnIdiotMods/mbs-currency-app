import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/enums.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.title,
    required this.balance,
    required this.partyAffiliation,
  });

  final String title;
  final double balance;
  final PartyAffiliation partyAffiliation;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$');
    final colors = partyAffiliation == PartyAffiliation.federalist
        ? [const Color(0xFF8E1C1C), const Color(0xFFC62828)]
        : [const Color(0xFF0D47A1), const Color(0xFF1565C0)];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: colors),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            formatter.format(balance),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
