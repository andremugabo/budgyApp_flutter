import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgy/providers/auth_provider';
import 'package:budgy/services/income_service.dart';
import 'package:budgy/services/expense_service.dart';
import 'package:budgy/services/api_service.dart';

class BalanceSummary extends StatefulWidget {
  const BalanceSummary({super.key});

  @override
  State<BalanceSummary> createState() => _BalanceSummaryState();
}

class _BalanceSummaryState extends State<BalanceSummary> {
  double? totalIncome;
  double? totalExpense;
  late final IncomeService _incomeService;
  late final ExpenseService _expenseService;
  Future<void>? _loadFuture;

  @override
  void initState() {
    super.initState();
    final api = ApiService();
    _incomeService = IncomeService(api);
    _expenseService = ExpenseService(api);
    _loadFuture = _load();
  }

  Future<void> _load() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    final incomes = await _incomeService.getByUser(user.id);
    final expenses = await _expenseService.getByUser(user.id);
    final incomeSum = incomes.fold<double>(0, (p, e) => p + e.amount);
    final expenseSum = expenses.fold<double>(0, (p, e) => p + e.amount);
    setState(() {
      totalIncome = incomeSum;
      totalExpense = expenseSum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        final ti = totalIncome;
        final te = totalExpense;
        final loading = snapshot.connectionState == ConnectionState.waiting && (ti == null || te == null);
        final balance = (ti ?? 0) - (te ?? 0);
        final ratio = (ti ?? 0) == 0 ? 0.0 : ((te ?? 0) / (ti ?? 1)).clamp(0.0, 1.0);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _BalanceTile(
                      icon: const Icon(Icons.account_balance_wallet, color: Colors.green),
                      label: "Total Balance",
                      amount: loading ? '...' : "${balance.toStringAsFixed(2)} Frw",
                      color: Colors.green,
                    ),
                    Container(width: 1.5, height: 40, color: Colors.grey.shade300),
                    _BalanceTile(
                      icon: const Icon(Icons.money_off, color: Colors.red),
                      label: "Total Expense",
                      amount: loading ? '...' : "-${(te ?? 0).toStringAsFixed(2)} Frw",
                      color: Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: loading ? null : ratio,
                    backgroundColor: Colors.grey.shade300,
                    color: Theme.of(context).colorScheme.primary,
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  loading ? "Loading..." : "${(ratio * 100).toStringAsFixed(0)}% of income spent",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      },
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
