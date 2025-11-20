import 'package:budgy/models/expense.dart';
import 'package:budgy/models/expense_category.dart';
import 'package:budgy/providers/auth_provider.dart';
import 'package:budgy/services/api_service.dart';
import 'package:budgy/services/expense_service.dart';
import 'package:budgy/services/expense_category_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgy/ui/widgets/custom_bottom_navigation.dart';
import 'package:budgy/ui/widgets/empty_state.dart';
import 'package:budgy/utils/error_utils.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  late final ExpenseService _service;
  late final ExpenseCategoryService _categoryService;
  List<Expense> _items = const [];
  List<ExpenseCategoryModel> _categories = const [];
  List<Expense> _filtered = const [];
  bool _loading = true;
  bool _searching = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    final api = ApiService();
    _service = ExpenseService(api);
    _categoryService = ExpenseCategoryService(api);
    _load();
  }

  Future<void> _load() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    try {
      final list = await _service.getByUser(user.id);
      final cats = await _categoryService.getAll();
      setState(() {
        _items = list;
        _categories = cats;
        _filtered = _applyFilter(list, _query);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      final message = errorMessageFrom(
        e,
        fallback: 'Failed to load expenses. Please try again.',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  List<Expense> _applyFilter(List<Expense> items, String query) {
    if (query.trim().isEmpty) return items;
    final q = query.toLowerCase();
    return items
        .where((e) =>
            (e.category?.name.toLowerCase() ?? '').contains(q) ||
            e.id.toLowerCase().contains(q) ||
            e.amount.toString().contains(q))
        .toList();
  }

  Future<void> _addExpense() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    final amountController = TextEditingController();
    String? selectedCategoryId = _categories.isNotEmpty ? _categories.first.id : null;
    final theme = Theme.of(context);
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Add Expense',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: 'e.g. 2500',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Amounts are in Frw',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategoryId,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                    .toList(),
                onChanged: (v) => selectedCategoryId = v,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (res == true && selectedCategoryId != null) {
      final amount = double.tryParse(amountController.text.trim()) ?? 0;
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid positive amount.')),
        );
        return;
      }
      try {
        await _service.create(userId: user.id, amount: amount, categoryId: selectedCategoryId!);
        await _load();
      } catch (e) {
        final message = errorMessageFrom(
          e,
          fallback: 'Failed to add expense. Please try again.',
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search expenses...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _query = value;
                    _filtered = _applyFilter(_items, _query);
                  });
                },
              )
            : const Text('Expenses'),
        actions: [
          IconButton(
            icon: Icon(_searching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _searching = !_searching;
                if (!_searching) {
                  _query = '';
                  _filtered = _applyFilter(_items, _query);
                }
              });
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: _filtered.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 80),
                        EmptyState(
                          message: 'No expenses yet. Add your first expense to get started.',
                          icon: Icons.shopping_cart,
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final e = _filtered[i];
                        return ListTile(
                          leading: const Icon(Icons.shopping_cart),
                          title: Text(e.category?.name ?? 'Expense'),
                          subtitle: Text(e.id),
                          trailing: Text('-${e.amount.toStringAsFixed(2)} Frw'),
                          onTap: () => _editExpense(e),
                          onLongPress: () => _confirmDelete(e),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExpense,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 3),
    );
  }

  Future<void> _editExpense(Expense e) async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    final amountController = TextEditingController(text: e.amount.toString());
    String? selectedCategoryId = e.category?.id ?? (_categories.isNotEmpty ? _categories.first.id : null);
    final theme = Theme.of(context);
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Edit Expense',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Amounts are in Frw',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategoryId,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                    .toList(),
                onChanged: (v) => selectedCategoryId = v,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (res == true && selectedCategoryId != null) {
      final amount = double.tryParse(amountController.text.trim()) ?? e.amount;
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid positive amount.')),
        );
        return;
      }
      try {
        await _service.update(id: e.id, userId: user.id, amount: amount, categoryId: selectedCategoryId!);
        await _load();
      } catch (e) {
        final message = errorMessageFrom(
          e,
          fallback: 'Failed to update expense. Please try again.',
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      }
    }
  }

  Future<void> _confirmDelete(Expense e) async {
    final theme = Theme.of(context);
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Expense',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (res == true) {
      try {
        await _service.deleteById(e.id);
        await _load();
      } catch (e) {
        final message = errorMessageFrom(
          e,
          fallback: 'Failed to delete expense. Please try again.',
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      }
    }
  }
}


