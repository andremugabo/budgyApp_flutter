import 'dart:io';

import 'package:budgy/models/user.dart';
import 'package:budgy/providers/auth_provider.dart';
import 'package:budgy/services/api_service.dart';
import 'package:budgy/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final UserService _service;
  late final ImagePicker _picker;
  XFile? _pickedImage;
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _email = TextEditingController();
  Gender _gender = Gender.MALE;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _service = UserService(ApiService());
    _picker = ImagePicker();
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading || authProvider.currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final currentUser = authProvider.currentUser!;
          final imageUrl = currentUser.image ?? '';
          final lastUpdated = currentUser.updatedAt ?? currentUser.createdAt;
          ImageProvider avatarImage;
          if (_pickedImage != null) {
            avatarImage = FileImage(File(_pickedImage!.path));
          } else if (imageUrl.isNotEmpty) {
            avatarImage = NetworkImage(imageUrl);
          } else {
            avatarImage = const AssetImage('assets/images/profile.jpg');
          }
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: avatarImage,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${currentUser.firstName} ${currentUser.lastName}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentUser.email,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          alignment: WrapAlignment.center,
                          children: [
                            Chip(
                              label: Text(currentUser.gender.name),
                              avatar: const Icon(
                                Icons.person_outline,
                                size: 18,
                              ),
                            ),
                            Chip(
                              label: Text(currentUser.role.name),
                              avatar: const Icon(
                                Icons.verified_user_outlined,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _first,
                            decoration: const InputDecoration(
                              labelText: 'First name',
                            ),
                            enabled: !_saving, // Disable during save
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _last,
                            decoration: const InputDecoration(
                              labelText: 'Last name',
                            ),
                            enabled: !_saving,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _email,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            enabled: !_saving,
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "We'll use this email to contact you.",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AbsorbPointer(
                            absorbing: _saving,
                            child: DropdownButtonFormField<Gender>(
                              value: _gender,
                              items: Gender.values
                                  .map(
                                    (g) => DropdownMenuItem(
                                      value: g,
                                      child: Text(g.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _gender = v ?? _gender),
                              decoration: const InputDecoration(
                                labelText: 'Gender',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saving ? null : _save,
                              child: _saving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Save changes'),
                            ),
                          ),
                          if (lastUpdated != null) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Last updated: ${DateFormat.yMMMd().add_Hm().format(lastUpdated)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.textTheme.bodySmall?.color
                                      ?.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
        image: _pickedImage != null ? _pickedImage!.path : current.image,
        dob: current.dob,
        role: current.role,
        createdAt: current.createdAt,
        updatedAt: current.updatedAt,
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

  Future<void> _pickImage() async {
    final result = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (result != null && mounted) {
      setState(() {
        _pickedImage = result;
      });
    }
  }
}
