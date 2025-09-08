import 'package:budgy/models/saving.dart';
import 'package:budgy/providers/auth_provider.dart';
import 'package:budgy/services/api_service.dart';
import 'package:budgy/services/saving_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgy/ui/widgets/custom_bottom_navigation.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  late final SavingService _service;
  List<Saving> _items = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _service = SavingService(ApiService());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Savings')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final s = _items[i];
                  final progress = s.targetAmount == 0
                      ? 0.0
                      : (s.currentAmount / s.targetAmount).clamp(0.0, 1.0);
                  return ListTile(
                    leading: const Icon(Icons.savings),
                    title: Text(s.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.priority.name),
                        LinearProgressIndicator(value: progress),
                      ],
                    ),
                    trailing: Text('${s.currentAmount.toStringAsFixed(0)}/${s.targetAmount.toStringAsFixed(0)}'),
                    onTap: () => _editSaving(s),
                    onLongPress: () => _confirmDelete(s),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSaving,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 1),
    );
  }

  Future<void> _addSaving() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    final name = TextEditingController();
    final target = TextEditingController();
    final current = TextEditingController(text: '0');
    final description = TextEditingController();
    SavingsPriority priority = SavingsPriority.MEDIUM;
    DateTime targetDate = DateTime.now().add(const Duration(days: 30));

    final res = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Add Saving Goal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: target, decoration: const InputDecoration(labelText: 'Target Amount'), keyboardType: TextInputType.number),
                TextField(controller: current, decoration: const InputDecoration(labelText: 'Current Amount'), keyboardType: TextInputType.number),
                TextField(controller: description, decoration: const InputDecoration(labelText: 'Description')),
                const SizedBox(height: 12),
                DropdownButtonFormField<SavingsPriority>(
                  value: priority,
                  items: SavingsPriority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                  onChanged: (v) => setStateDialog(() => priority = v ?? SavingsPriority.MEDIUM),
                  decoration: const InputDecoration(labelText: 'Priority'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Text('Target date: ${targetDate.toLocal().toString().split(' ').first}')),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                          initialDate: targetDate,
                        );
                        if (picked != null) setStateDialog(() => targetDate = picked);
                      },
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Add')),
          ],
        ),
      ),
    );
    if (res == true) {
      await _service.create(
        userId: user.id,
        name: name.text.trim(),
        targetAmount: double.tryParse(target.text.trim()) ?? 0,
        currentAmount: double.tryParse(current.text.trim()) ?? 0,
        targetDate: targetDate,
        priority: priority,
        description: description.text.trim(),
      );
      await _load();
    }
  }

  Future<void> _editSaving(Saving s) async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    final name = TextEditingController(text: s.name);
    final target = TextEditingController(text: s.targetAmount.toString());
    final current = TextEditingController(text: s.currentAmount.toString());
    final description = TextEditingController(text: s.description);
    SavingsPriority priority = s.priority;
    DateTime targetDate = s.targetDate;

    final res = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Edit Saving Goal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: target, decoration: const InputDecoration(labelText: 'Target Amount'), keyboardType: TextInputType.number),
                TextField(controller: current, decoration: const InputDecoration(labelText: 'Current Amount'), keyboardType: TextInputType.number),
                TextField(controller: description, decoration: const InputDecoration(labelText: 'Description')),
                const SizedBox(height: 12),
                DropdownButtonFormField<SavingsPriority>(
                  value: priority,
                  items: SavingsPriority.values.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                  onChanged: (v) => setStateDialog(() => priority = v ?? s.priority),
                  decoration: const InputDecoration(labelText: 'Priority'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Text('Target date: ${targetDate.toLocal().toString().split(' ').first}')),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                          initialDate: targetDate,
                        );
                        if (picked != null) setStateDialog(() => targetDate = picked);
                      },
                      child: const Text('Pick Date'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
          ],
        ),
      ),
    );
    if (res == true) {
      await _service.update(
        id: s.id,
        userId: user.id,
        name: name.text.trim(),
        targetAmount: double.tryParse(target.text.trim()) ?? s.targetAmount,
        currentAmount: double.tryParse(current.text.trim()) ?? s.currentAmount,
        targetDate: targetDate,
        priority: priority,
        description: description.text.trim(),
      );
      await _load();
    }
  }

  Future<void> _confirmDelete(Saving s) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Saving'),
        content: const Text('Are you sure you want to delete this saving goal?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (res == true) {
      await _service.deleteById(s.id);
      await _load();
    }
  }
}


