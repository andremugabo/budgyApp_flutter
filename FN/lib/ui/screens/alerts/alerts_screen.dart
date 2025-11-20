import 'dart:convert';

import 'package:budgy/models/alert.dart';
import 'package:budgy/providers/auth_provider.dart';
import 'package:budgy/services/api_service.dart';
import 'package:budgy/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgy/ui/widgets/empty_state.dart';
import 'package:budgy/utils/error_utils.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<AlertModel> _items = const [];
  bool _loading = true;
  late final AlertService _service;

  @override
  void initState() {
    super.initState();
    _service = AlertService(ApiService());
    // Defer _load() to after the first frame to safely access context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future<void> _load() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) {
      if (mounted) {
        setState(() => _loading = false);
      }
      return;
    }
    if (mounted) {
      setState(() => _loading = true);
    }
    try {
      final api = ApiService();
      final res = await api.get('/api/alerts/user/${user.id}');
      final list = (jsonDecode(res.body) as List<dynamic>)
          .map((e) => AlertModel.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) {
          // Unread first
          if (a.isRead == b.isRead) return 0;
          return a.isRead ? 1 : -1;
        });
      if (mounted) {
        setState(() {
          _items = list;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        final message = errorMessageFrom(
          e,
          fallback: 'Failed to load alerts. Please try again.',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  Future<void> _markRead(AlertModel alert) async {
    try {
      final updated = await _service.markRead(alert);
      if (updated != null && mounted) {
        setState(() {
          _items = _items.map((a) => a.id == alert.id ? updated : a).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        final message = errorMessageFrom(
          e,
          fallback: 'Failed to update alert. Please try again.',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _load,
        child: _items.isEmpty
            ? ListView(
          children: const [
            SizedBox(height: 80),
            EmptyState(
              message: 'No alerts at the moment.',
              icon: Icons.notifications_none,
            ),
          ],
        )
            : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final a = _items[i];
            final color = a.alert == AlertType.ERROR
                ? Colors.red
                : a.alert == AlertType.WARNING
                ? Colors.amber
                : a.alert == AlertType.SUCCESS
                ? Colors.green
                : Colors.blueGrey;
            return ListTile(
              leading: Icon(
                a.alert == AlertType.ERROR
                    ? Icons.error
                    : a.alert == AlertType.WARNING
                    ? Icons.warning
                    : a.alert == AlertType.SUCCESS
                    ? Icons.check_circle
                    : Icons.info,
                color: color,
              ),
              title: Text(
                a.title,
                style: a.isRead
                    ? null
                    : Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                a.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: a.isRead
                  ? null
                  : TextButton(
                onPressed: () => _markRead(a),
                child: const Text('Mark Read'),
              ),
            );
          },
        ),
      ),
    );
  }
}