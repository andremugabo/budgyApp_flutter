import 'package:flutter/material.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Security',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your password, sign-in methods and other security related options.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          SwitchListTile.adaptive(
            value: true,
            onChanged: (_) {},
            title: const Text('Use device biometrics'),
            subtitle: const Text('Face ID / Touch ID / Fingerprint'),
          ),
          SwitchListTile.adaptive(
            value: true,
            onChanged: (_) {},
            title: const Text('Require login on app start'),
            subtitle: const Text('For extra protection on this device'),
          ),
          ListTile(
            leading: const Icon(Icons.lock_reset_outlined),
            title: const Text('Change password'),
            subtitle: const Text('Update your Budgy account password'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
