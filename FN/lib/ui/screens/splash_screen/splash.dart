import 'package:budgy/ui/screens/home/dashboard_screen.dart';
import 'package:budgy/ui/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgy/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Show loading spinner while AuthProvider is initializing
          if (authProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...'),
                ],
              ),
            );
          }

          // When initialization is complete, navigate based on auth state
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return; // prevent setState after dispose
            if (authProvider.isAuthenticated) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          });

          // Show nothing while navigation is happening
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
