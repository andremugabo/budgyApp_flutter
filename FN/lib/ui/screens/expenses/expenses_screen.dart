import 'package:budgy/models/expense.dart';
import 'package:budgy/models/expense_category.dart';
import 'package:budgy/providers/auth_provider';
import 'package:budgy/services/api_service.dart';
import 'package:budgy/services/expense_service.dart';
import 'package:budgy/services/expense_category_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgy/ui/widgets/custom_bottom_navigation.dart';

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
  bool _loading = true;

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
    if (user == null) return;
    final list = await _service.getByUser(user.id);
    final cats = await _categoryService.getAll();
    setState(() {
      _items = list;
      _categories = cats;
      _loading = false;
    });
  }

  Future<void> _addExpense() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    final amountController = TextEditingController();
    String? selectedCategoryId = _categories.isNotEmpty ? _categories.first.id : null;
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
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
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Add')),
        ],
      ),
    );
    if (res == true && selectedCategoryId != null) {
      final amount = double.tryParse(amountController.text.trim()) ?? 0;
      await _service.create(userId: user.id, amount: amount, categoryId: selectedCategoryId!);
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final e = _items[i];
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
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
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
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );
    if (res == true && selectedCategoryId != null) {
      final amount = double.tryParse(amountController.text.trim()) ?? e.amount;
      await _service.update(id: e.id, userId: user.id, amount: amount, categoryId: selectedCategoryId!);
      await _load();
    }
  }

  Future<void> _confirmDelete(Expense e) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (res == true) {
      await _service.deleteById(e.id);
      await _load();
    }
  }
}


