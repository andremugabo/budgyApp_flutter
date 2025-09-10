import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgy/providers/auth_provider.dart';
import 'package:budgy/providers/theme_provider.dart';
import 'package:budgy/ui/screens/splash_screen/splash.dart';

void main() => runApp(const BudgyApp());

class BudgyApp extends StatelessWidget {
  const BudgyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Student Budget Tracker App',
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: theme.mode,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
