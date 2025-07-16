import 'package:budgy/ui/widgets/balance_summary.dart';
import 'package:budgy/ui/widgets/custom_app_bar.dart';
import 'package:budgy/ui/widgets/custom_bottom_navigation.dart';
import 'package:budgy/ui/widgets/income_section.dart';
import 'package:budgy/ui/widgets/saving_goals_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            BalanceSummary(),
            SizedBox(height: 20),
            SavingGoalsCard(),
            SizedBox(height: 20),
            IncomeSection(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
