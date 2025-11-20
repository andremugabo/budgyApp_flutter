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
import 'package:budgy/utils/error_utils.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  List<Income> _recentIncome = const [];
  List<Expense> _recentExpenses = const [];
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecent();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadRecent() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final api = ApiService();
      final incomes = await IncomeService(api).getByUser(user.id);
      final expenses = await ExpenseService(api).getByUser(user.id);
      if (mounted) {
        setState(() {
          _recentIncome = incomes.take(5).toList();
          _recentExpenses = expenses.take(5).toList();
          _isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        final message = errorMessageFrom(
          e,
          fallback: 'Error loading data. Please try again.',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(message)),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade700,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _confirmDeleteIncome(String id) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red.shade400),
            const SizedBox(width: 12),
            const Text('Delete Income'),
          ],
        ),
        content: const Text('Are you sure you want to delete this income entry? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (res == true && mounted) {
      try {
        final api = ApiService();
        await IncomeService(api).deleteById(id);
        await _loadRecent();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Income deleted successfully'),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessageFrom(e, fallback: 'Failed to delete income')),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      }
    }
  }

  Future<void> _confirmDeleteExpense(String id) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red.shade400),
            const SizedBox(width: 12),
            const Text('Delete Expense'),
          ],
        ),
        content: const Text('Are you sure you want to delete this expense entry? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (res == true && mounted) {
      try {
        final api = ApiService();
        await ExpenseService(api).deleteById(id);
        await _loadRecent();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Expense deleted successfully'),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessageFrom(e, fallback: 'Failed to delete expense')),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        return Scaffold(
          appBar: const CustomAppBar(),
          body: RefreshIndicator(
            onRefresh: _loadRecent,
            color: theme.colorScheme.primary,
            child: _isLoading
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading your dashboard...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            )
                : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(isWide ? 32.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BalanceSummary(),
                    const SizedBox(height: 24),
                    _EnhancedTotalsChart(
                      incomes: _recentIncome,
                      expenses: _recentExpenses,
                    ),
                    const SizedBox(height: 24),
                    const SavingGoalsCard(),
                    const SizedBox(height: 32),
                    _SectionHeader(
                      title: 'Recent Transactions',
                      icon: Icons.history,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    TransactionSection(
                      sectionTitle: "Income",
                      color: Colors.green.shade600,
                      items: _recentIncome.isEmpty
                          ? [
                        TransactionItem(
                          icon: Icons.trending_up,
                          title: "No recent income",
                          date: 'Start adding income to track your earnings',
                          amount: "0.00 Frw",
                          extra: null,
                        )
                      ]
                          : _recentIncome
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
                    const SizedBox(height: 16),
                    TransactionSection(
                      sectionTitle: "Expenses",
                      color: Colors.red.shade600,
                      items: _recentExpenses.isEmpty
                          ? [
                        TransactionItem(
                          icon: Icons.shopping_cart,
                          title: "No recent expenses",
                          date: 'Start tracking your spending',
                          amount: "0.00 Frw",
                          extra: null,
                        )
                      ]
                          : _recentExpenses
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
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: isWide ? null : const CustomBottomNavigation(),
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _EnhancedTotalsChart extends StatelessWidget {
  const _EnhancedTotalsChart({
    required this.incomes,
    required this.expenses,
  });

  final List<Income> incomes;
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalIncome = incomes.fold<double>(0, (sum, e) => sum + e.amount);
    final totalExpense = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    final balance = totalIncome - totalExpense;
    final maxValue = [totalIncome, totalExpense, 1].reduce((a, b) => a > b ? a : b);

    double _barHeight(double value) {
      const maxBarHeight = 140.0;
      return (value / maxValue) * maxBarHeight;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Financial Overview',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This period',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: balance >= 0
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        balance >= 0 ? Icons.trending_up : Icons.trending_down,
                        size: 16,
                        color: balance >= 0 ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        balance >= 0 ? 'Positive' : 'Deficit',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: balance >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: _barHeight(totalIncome)),
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Container(
                                  height: value,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.green.shade400,
                                        Colors.green.shade600,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Icon(Icons.trending_up, color: Colors.green.shade600, size: 20),
                        const SizedBox(height: 4),
                        Text(
                          'Income',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '+${totalIncome.toStringAsFixed(0)} Frw',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: _barHeight(totalExpense)),
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Container(
                                  height: value,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red.shade400,
                                        Colors.red.shade600,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Icon(Icons.trending_down, color: Colors.red.shade600, size: 20),
                        const SizedBox(height: 4),
                        Text(
                          'Expenses',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '-${totalExpense.toStringAsFixed(0)} Frw',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.red.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}