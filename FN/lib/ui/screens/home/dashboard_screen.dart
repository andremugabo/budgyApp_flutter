import 'package:budgy/ui/widgets/balance_summary.dart';
import 'package:budgy/ui/widgets/custom_app_bar.dart';
import 'package:budgy/ui/widgets/custom_bottom_navigation.dart';
import 'package:budgy/ui/widgets/saving_goals_card.dart';
import 'package:budgy/ui/widgets/transaction_section.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BalanceSummary(),
            const SizedBox(height: 20),
            const SavingGoalsCard(),
            const SizedBox(height: 20),

            // Income Section
            TransactionSection(
              sectionTitle: "Income",
              color: Colors.green,
              items: [
                TransactionItem(
                  icon: Icons.work,
                  title: "Salary",
                  date: "18:27 - April 30",
                  amount: "800,000 Frw",
                ),
                TransactionItem(
                  icon: Icons.card_giftcard,
                  title: "Allowance",
                  date: "18:27 - April 30",
                  amount: "300,000 Frw",
                ),
                TransactionItem(
                  icon: Icons.trending_up,
                  title: "Investment",
                  date: "18:27 - April 30",
                  amount: "500,000 Frw",
                ),
                TransactionItem(
                  icon: Icons.account_balance,
                  title: "Interest",
                  date: "18:27 - April 30",
                  amount: "200,000 Frw",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Savings Section
            TransactionSection(
              sectionTitle: "Savings",
              color: Colors.blue,
              items: [
                TransactionItem(
                  icon: Icons.savings,
                  title: "Emergency Fund",
                  date: "18:27 - April 30",
                  amount: "500,000 Frw",
                ),
                TransactionItem(
                  icon: Icons.savings,
                  title: "Vacation Fund",
                  date: "18:27 - April 30",
                  amount: "200,000 Frw",
                ),
                TransactionItem(
                  icon: Icons.house,
                  title: "Home Savings",
                  date: "18:27 - April 30",
                  amount: "600,000 Frw",
                ),
                TransactionItem(
                  icon: Icons.school,
                  title: "Education Savings",
                  date: "18:27 - April 30",
                  amount: "300,000 Frw",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Expenses Section
            TransactionSection(
              sectionTitle: "Expenses",
              color: Colors.red,
              items: [
                TransactionItem(
                  icon: Icons.fastfood,
                  title: "Food",
                  date: "18:27 - April 30",
                  amount: "150,000 Frw",
                ),
                TransactionItem(
                  icon: Icons.directions_bus,
                  title: "Transport",
                  date: "18:27 - April 30",
                  amount: "50,000 Frw",
                ),
                TransactionItem(
                  icon: Icons.local_hospital,
                  title: "Health",
                  date: "18:27 - April 30",
                  amount: "120,000 Frw",
                ),
                TransactionItem(
                  icon: Icons.shopping_cart,
                  title: "Shopping",
                  date: "18:27 - April 30",
                  amount: "250,000 Frw",
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
