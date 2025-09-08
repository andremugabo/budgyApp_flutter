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
import 'package:budgy/providers/auth_provider.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Income> _recentIncome = const [];
  List<Expense> _recentExpenses = const [];
  bool _isLoading = false; // Added for UX

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    if (!mounted) return; // Async safety
    setState(() => _isLoading = true);
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }
    try {
      final api = ApiService();
      final incomes = await IncomeService(api).getByUser(user.id);
      final expenses = await ExpenseService(api).getByUser(user.id);
      if (mounted) {
        setState(() {
          _recentIncome = incomes.take(4).toList();
          _recentExpenses = expenses.take(4).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  Future<void> _confirmDeleteIncome(String id) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Delete Income'),
        content: Text('Delete this recent income?'),
        actions: [
          TextButton(
            onPressed: null, // Set to null for const
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: null, // Set to null for const
            child: Text('Delete'),
          ),
        ],
      ),
    );
    if (res == true && mounted) {
      final api = ApiService();
      await IncomeService(api).deleteById(id);
      await _loadRecent();
    }
  }

  Future<void> _confirmDeleteExpense(String id) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Delete Expense'),
        content: Text('Delete this recent expense?'),
        actions: [
          TextButton(
            onPressed: null, // Set to null for const
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: null, // Set to null for const
            child: Text('Delete'),
          ),
        ],
      ),
    );
    if (res == true && mounted) {
      final api = ApiService();
      await ExpenseService(api).deleteById(id);
      await _loadRecent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600; // Web or tablet
        return Scaffold(
          appBar: const CustomAppBar(),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(isWide ? 32.0 : 16.0),
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
                        items: _recentIncome.isEmpty
                            ? [
                                TransactionItem(
                                  icon: Icons.trending_up,
                                  title: "No recent income",
                                  date: '',
                                  amount: "0.00 Frw",
                                  extra: null,
                                )
                              ]
                            : _recentIncome
                                .map((e) => TransactionItem(
                                      icon: Icons.trending_up,
                                      title: e.source,
                                      date: '',
                                      amount:
                                          "+${e.amount.toStringAsFixed(2)} Frw",
                                      extra: {'type': 'income', 'id': e.id},
                                    ))
                                .toList(), // Added .toList() to fix type error
                        onItemLongPress: (item) {
                          final id = item.extra?['id'] as String?;
                          if (id != null) _confirmDeleteIncome(id);
                        },
                      ),
                      const SizedBox(height: 20),
                      // Savings Section (static)
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
                        items: _recentExpenses.isEmpty
                            ? [
                                TransactionItem(
                                  icon: Icons.shopping_cart,
                                  title: "No recent expenses",
                                  date: '',
                                  amount: "0.00 Frw",
                                  extra: null,
                                )
                              ]
                            : _recentExpenses
                                .map((e) => TransactionItem(
                                      icon: Icons.shopping_cart,
                                      title: e.category?.name ?? 'Expense',
                                      date: '',
                                      amount:
                                          "-${e.amount.toStringAsFixed(2)} Frw",
                                      extra: {'type': 'expense', 'id': e.id},
                                    ))
                                .toList(), // Added .toList() to fix type error
                        onItemLongPress: (item) {
                          final id = item.extra?['id'] as String?;
                          if (id != null) _confirmDeleteExpense(id);
                        },
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: isWide
              ? null // Hide nav bar on wide screens (web)
              : const CustomBottomNavigation(),
        );
      },
    );
  }
}
