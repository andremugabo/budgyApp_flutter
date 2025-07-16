import 'package:flutter/material.dart';

class BalanceSummary extends StatelessWidget {
  const BalanceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BalanceTile(
              icon: Icon(Icons.account_balance_wallet, color: Colors.green),
              label: "Total Balance",
              amount: "35,650 Frw",
              color: Colors.green,
            ),
            Container(width: 1.5, height: 40, color: Colors.grey.shade300),
            _BalanceTile(
              icon: Icon(Icons.money_off, color: Colors.red),
              label: "Total Expense",
              amount: "-1,780 Frw",
              color: Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: 0.35,
          backgroundColor: Colors.grey.shade300,
          color: Colors.blue,
          minHeight: 10,
        ),
        const SizedBox(height: 8),
        Text(
          "35% Of Your Expenses, Look Good.",
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _BalanceTile extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final Icon icon;

  const _BalanceTile({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            icon,
            SizedBox(width: 6),
            Text(label, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),

        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
