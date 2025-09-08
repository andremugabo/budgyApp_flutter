import 'package:budgy/models/user.dart';
import 'package:budgy/providers/auth_provider.dart';
import 'package:budgy/services/api_service.dart';
import 'package:budgy/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final UserService _service;
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  Gender _gender = Gender.OTHER;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _service = UserService(ApiService());
    final user = context.read<AuthProvider>().currentUser;
    if (user != null) {
      _first.text = user.firstName;
      _last.text = user.lastName;
      _email.text = user.email;
      _gender = user.gender;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _first, decoration: const InputDecoration(labelText: 'First name')),
            TextField(controller: _last, decoration: const InputDecoration(labelText: 'Last name')),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            DropdownButtonFormField<Gender>(
              value: _gender,
              items: Gender.values.map((g) => DropdownMenuItem(value: g, child: Text(g.name))).toList(),
              onChanged: (v) => setState(() => _gender = v ?? _gender),
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving ? const CircularProgressIndicator() : const Text('Save changes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final current = context.read<AuthProvider>().currentUser;
    if (current == null) return;
    setState(() => _saving = true);
    final updated = await _service.updateUser(User(
      id: current.id,
      firstName: _first.text.trim(),
      lastName: _last.text.trim(),
      email: _email.text.trim(),
      gender: _gender,
      image: current.image,
      dob: current.dob,
      role: current.role,
    ));
    await context.read<AuthProvider>().setCurrentUser(updated);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }
}


