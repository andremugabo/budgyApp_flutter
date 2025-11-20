import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Help Center',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Find quick answers to common questions or contact support.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _FaqItem(
            question: 'How do I add a new income?',
            answer: 'Go to the dashboard and use the Income section to record a new entry.',
          ),
          _FaqItem(
            question: 'Can I edit or delete a transaction?',
            answer: 'Long press on an item in Recent Transactions to delete it.',
          ),
          _FaqItem(
            question: 'Where is my data stored?',
            answer: 'Your data is stored securely on the Budgy backend for your account only.',
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Contact support'),
            subtitle: const Text('support@budgy.app'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
