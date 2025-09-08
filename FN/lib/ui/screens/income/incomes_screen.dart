import 'package:budgy/models/income.dart';
import 'package:budgy/providers/auth_provider.dart';
import 'package:budgy/services/api_service.dart';
import 'package:budgy/services/income_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgy/ui/widgets/custom_bottom_navigation.dart';

class IncomesScreen extends StatefulWidget {
  const IncomesScreen({super.key});

  @override
  State<IncomesScreen> createState() => _IncomesScreenState();
}

class _IncomesScreenState extends State<IncomesScreen> {
  late final IncomeService _service;
  List<Income> _items = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _service = IncomeService(ApiService());
    _load();
  }

  Future<void> _load() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    final list = await _service.getByUser(user.id);
    setState(() {
      _items = list;
      _loading = false;
    });
  }

  Future<void> _addIncome() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    final amount = TextEditingController();
    final source = TextEditingController();
    final description = TextEditingController();
    IncomeType type = IncomeType.SALARY;
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Income'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: amount, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
              TextField(controller: source, decoration: const InputDecoration(labelText: 'Source')),
              TextField(controller: description, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 12),
              DropdownButtonFormField<IncomeType>(
                value: type,
                items: IncomeType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                onChanged: (v) => type = v ?? IncomeType.SALARY,
                decoration: const InputDecoration(labelText: 'Type'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Add')),
        ],
      ),
    );
    if (res == true) {
      await _service.create(
        userId: user.id,
        amount: double.tryParse(amount.text.trim()) ?? 0,
        source: source.text.trim(),
        incomeType: type,
        description: description.text.trim(),
      );
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Income')),
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
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Income'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: amount, decoration: const InputDecoration(labelText: 'Amount'), keyboardType: TextInputType.number),
              TextField(controller: source, decoration: const InputDecoration(labelText: 'Source')),
              TextField(controller: description, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 12),
              DropdownButtonFormField<IncomeType>(
                value: type,
                items: IncomeType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                onChanged: (v) => type = v ?? e.incomeType,
                decoration: const InputDecoration(labelText: 'Type'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    );
    if (res == true) {
      await _service.update(
        id: e.id,
        userId: user.id,
        amount: double.tryParse(amount.text.trim()) ?? e.amount,
        source: source.text.trim(),
        incomeType: type,
        description: description.text.trim(),
      );
      await _load();
    }
  }

  Future<void> _confirmDelete(Income e) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Income'),
        content: const Text('Are you sure you want to delete this income?'),
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


