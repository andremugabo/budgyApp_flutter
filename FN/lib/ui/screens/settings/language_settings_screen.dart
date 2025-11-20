import 'package:flutter/material.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selected = 'en';

  final _languages = const [
    {'code': 'en', 'label': 'English'},
    {'code': 'fr', 'label': 'French'},
    {'code': 'rw', 'label': 'Kinyarwanda'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Language',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the language you would like Budgy to use.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ..._languages.map((lang) {
            final code = lang['code']!;
            final label = lang['label']!;
            final selected = _selected == code;
            return RadioListTile<String>(
              value: code,
              groupValue: _selected,
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selected = v);
              },
              title: Text(label),
              secondary: selected ? const Icon(Icons.check_circle, color: Colors.green) : null,
            );
          }),
        ],
      ),
    );
  }
}
