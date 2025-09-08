import 'dart:convert';

import 'package:budgy/models/alert.dart';
import 'package:budgy/providers/auth_provider.dart';
import 'package:budgy/services/api_service.dart';
import 'package:budgy/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    _load();
  }

  Future<void> _load() async {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) return;
    final api = ApiService();
    final res = await api.get('/api/alerts/user/${user.id}');
    final list = (jsonDecode(res.body) as List<dynamic>)
        .map((e) => AlertModel.fromJson(e as Map<String, dynamic>))
        .toList();
    setState(() {
      _items = list;
      _loading = false;
    });
  }

  Future<void> _markRead(AlertModel alert) async {
    final updated = await _service.markRead(alert);
    if (updated != null) {
      setState(() {
        _items = _items.map((a) => a.id == alert.id ? updated : a).toList();
      });
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
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final a = _items[i];
                  return ListTile(
                    leading: Icon(
                      a.alert == AlertType.ERROR
                          ? Icons.error
                          : a.alert == AlertType.WARNING
                              ? Icons.warning
                              : a.alert == AlertType.SUCCESS
                                  ? Icons.check_circle
                                  : Icons.info,
                      color: Colors.blue,
                    ),
                    title: Text(a.title),
                    subtitle: Text(a.message),
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


