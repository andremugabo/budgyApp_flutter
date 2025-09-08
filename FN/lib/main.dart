import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgy/providers/auth_provider';
import 'package:budgy/ui/screens/splash_screen/splash.dart';

void main() => runApp(const BudgyApp());

class BudgyApp extends StatefulWidget {
  const BudgyApp({super.key});

  @override
  State<BudgyApp> createState() => _BudgyAppState();
}

class _BudgyAppState extends State<BudgyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Student Budget Tracker App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashScreen(),
      ),
    );
  }
}
