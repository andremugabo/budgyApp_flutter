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
    // Safe init after mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final user = context.read<AuthProvider>().currentUser;
        if (user != null) {
          _first.text = user.firstName;
          _last.text = user.lastName;
          _email.text = user.email;
          _gender = user.gender;
        }
      }
    });
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _email.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    // Simple regex for email validation
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  bool _validateForm() {
    final firstName = _first.text.trim();
    final lastName = _last.text.trim();
    final email = _email.text.trim();
    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return false;
    }
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading || authProvider.currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final currentUser = authProvider.currentUser!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _first,
                  decoration: const InputDecoration(labelText: 'First name'),
                  enabled: !_saving, // Disable during save
                ),
                TextField(
                  controller: _last,
                  decoration: const InputDecoration(labelText: 'Last name'),
                  enabled: !_saving,
                ),
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_saving,
                ),
                const SizedBox(height: 12),
                AbsorbPointer(
                  absorbing: _saving,
                  child: DropdownButtonFormField<Gender>(
                    value: _gender,
                    items: Gender.values
                        .map((g) => DropdownMenuItem(
                              value: g,
                              child: Text(g.name),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _gender = v ?? _gender),
                    decoration: const InputDecoration(labelText: 'Gender'),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save changes'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _save() async {
    if (!_validateForm()) return;

    final current = context.read<AuthProvider>().currentUser;
    if (current == null) return;
    try {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}
