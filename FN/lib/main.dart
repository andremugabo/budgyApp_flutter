import 'package:budgy/ui/screens/home/dashboard_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(BudgyApp());

class BudgyApp extends StatefulWidget {
  const BudgyApp({super.key});

  @override
  State<BudgyApp> createState() => _BudgyAppState();
}

class _BudgyAppState extends State<BudgyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Budget Tracker App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DashboardScreen(),
    );
  }
}
