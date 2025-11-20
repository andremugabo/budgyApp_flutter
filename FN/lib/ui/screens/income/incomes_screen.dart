import 'package:budgy/models/income.dart';
import 'package:budgy/providers/auth_provider.dart';
import 'package:budgy/services/api_service.dart';
import 'package:budgy/services/income_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgy/ui/widgets/custom_bottom_navigation.dart';
import 'package:budgy/ui/widgets/empty_state.dart';
import 'package:budgy/utils/error_utils.dart';

class IncomesScreen extends StatefulWidget {
  const IncomesScreen({super.key});

  @override
  State<IncomesScreen> createState() => _IncomesScreenState();
}

class _IncomesScreenState extends State<IncomesScreen> {
  late final IncomeService _service;
  List<Income> _items = const [];
  List<Income> _filtered = const [];
  bool _loading = true;
  bool _searching = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _service = IncomeService(ApiService());
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
      setState(() {
        _items = list;
        _filtered = _applyFilter(list, _query);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      final message = errorMessageFrom(
        e,
        fallback: 'Failed to load income. Please try again.',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  List<Income> _applyFilter(List<Income> items, String query) {
    if (query.trim().isEmpty) return items;
    final q = query.toLowerCase();
    return items
        .where((e) =>
            e.source.toLowerCase().contains(q) ||
            e.description.toLowerCase().contains(q) ||
            e.incomeType.name.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _addIncome() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    final amount = TextEditingController();
    final source = TextEditingController();
    final description = TextEditingController();
    IncomeType type = IncomeType.SALARY;
    final theme = Theme.of(context);
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Add Income',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amount,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  hintText: 'e.g. 5000',
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
              const SizedBox(height: 8),
              TextField(
                controller: source,
                decoration: const InputDecoration(
                  labelText: 'Source',
                  hintText: 'e.g. Part-time job',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: description,
                decoration:
                    const InputDecoration(labelText: 'Description (optional)'),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<IncomeType>(
                value: type,
                items: IncomeType.values
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.name),
                        ))
                    .toList(),
                onChanged: (v) => type = v ?? IncomeType.SALARY,
                decoration: const InputDecoration(labelText: 'Type'),
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
    if (res == true) {
      final parsedAmount = double.tryParse(amount.text.trim()) ?? 0;
      final src = source.text.trim();
      if (parsedAmount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid positive amount.')),
        );
        return;
      }
      if (src.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter an income source.')),
        );
        return;
      }
      try {
        await _service.create(
          userId: user.id,
          amount: parsedAmount,
          source: src,
          incomeType: type,
          description: description.text.trim(),
        );
        await _load();
      } catch (e) {
        final message = errorMessageFrom(
          e,
          fallback: 'Failed to add income. Please try again.',
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
                  hintText: 'Search income...',
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
            : const Text('Income'),
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
                          message: 'No income records yet. Add your first income.',
                          icon: Icons.trending_up,
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
                          leading: const Icon(Icons.trending_up),
                          title: Text(e.source),
                          subtitle: Text(e.incomeType.name),
                          trailing: Text('+${e.amount.toStringAsFixed(2)} Frw'),
                          onTap: () => _editIncome(e),
                          onLongPress: () => _confirmDelete(e),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addIncome,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 2),
    );
  }

  Future<void> _editIncome(Income e) async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    final amount = TextEditingController(text: e.amount.toString());
    final source = TextEditingController(text: e.source);
    final description = TextEditingController(text: e.description);
    IncomeType type = e.incomeType;
    final theme = Theme.of(context);
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Edit Income',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amount,
                decoration: const InputDecoration(labelText: 'Amount'),
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
              const SizedBox(height: 8),
              TextField(
                controller: source,
                decoration: const InputDecoration(labelText: 'Source'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: description,
                decoration:
                    const InputDecoration(labelText: 'Description (optional)'),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<IncomeType>(
                value: type,
                items: IncomeType.values
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.name),
                        ))
                    .toList(),
                onChanged: (v) => type = v ?? e.incomeType,
                decoration: const InputDecoration(labelText: 'Type'),
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
    if (res == true) {
      final parsedAmount = double.tryParse(amount.text.trim()) ?? e.amount;
      final src = source.text.trim();
      if (parsedAmount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid positive amount.')),
        );
        return;
      }
      if (src.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter an income source.')),
        );
        return;
      }
      try {
        await _service.update(
          id: e.id,
          userId: user.id,
          amount: parsedAmount,
          source: src,
          incomeType: type,
          description: description.text.trim(),
        );
        await _load();
      } catch (e) {
        final message = errorMessageFrom(
          e,
          fallback: 'Failed to update income. Please try again.',
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      }
    }
  }

  Future<void> _confirmDelete(Income e) async {
    final theme = Theme.of(context);
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Income',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to delete this income?'),
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
          fallback: 'Failed to delete income. Please try again.',
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


