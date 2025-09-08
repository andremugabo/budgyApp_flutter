import 'package:budgy/ui/widgets/balance_summary.dart';
import 'package:budgy/ui/widgets/custom_app_bar.dart';
import 'package:budgy/ui/widgets/custom_bottom_navigation.dart';
import 'package:budgy/ui/widgets/saving_goals_card.dart';
import 'package:budgy/ui/widgets/transaction_section.dart';
import 'package:budgy/models/income.dart';
import 'package:budgy/models/expense.dart';
import 'package:budgy/services/api_service.dart';
import 'package:budgy/services/income_service.dart';
import 'package:budgy/services/expense_service.dart';
import 'package:provider/provider.dart';
import 'package:budgy/providers/auth_provider';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Income> _recentIncome = const [];
  List<Expense> _recentExpenses = const [];

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    final api = ApiService();
    final incomes = await IncomeService(api).getByUser(user.id);
    final expenses = await ExpenseService(api).getByUser(user.id);
    setState(() {
      _recentIncome = incomes.take(4).toList();
      _recentExpenses = expenses.take(4).toList();
    });
  }

  Future<void> _confirmDeleteIncome(String id) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Income'),
        content: const Text('Delete this recent income?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (res == true) {
      final api = ApiService();
      await IncomeService(api).deleteById(id);
      await _loadRecent();
    }
  }

  Future<void> _confirmDeleteExpense(String id) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Delete this recent expense?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (res == true) {
      final api = ApiService();
      await ExpenseService(api).deleteById(id);
      await _loadRecent();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BalanceSummary(),
            const SizedBox(height: 20),
            const SavingGoalsCard(),
            const SizedBox(height: 20),

            // Income Section
            TransactionSection(
              sectionTitle: "Income",
              color: Colors.green,
              items: _recentIncome
                  .map((e) => TransactionItem(
                        icon: Icons.trending_up,
                        title: e.source,
                        date: '',
                        amount: "+${e.amount.toStringAsFixed(2)} Frw",
                        extra: {'type': 'income', 'id': e.id},
                      ))
                  .toList(),
              onItemLongPress: (item) {
                final id = item.extra?['id'] as String?;
                if (id != null) _confirmDeleteIncome(id);
              },
            ),

            const SizedBox(height: 20),

            // Savings Section
            // Savings section left as static for now
            TransactionSection(
              sectionTitle: "Savings",
              color: Colors.blue,
              items: const [],
            ),

            const SizedBox(height: 20),

            // Expenses Section
            TransactionSection(
              sectionTitle: "Expenses",
              color: Colors.red,
              items: _recentExpenses
                  .map((e) => TransactionItem(
                        icon: Icons.shopping_cart,
                        title: e.category?.name ?? 'Expense',
                        date: '',
                        amount: "-${e.amount.toStringAsFixed(2)} Frw",
                        extra: {'type': 'expense', 'id': e.id},
                      ))
                  .toList(),
              onItemLongPress: (item) {
                final id = item.extra?['id'] as String?;
                if (id != null) _confirmDeleteExpense(id);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
