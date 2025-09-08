import 'package:flutter/material.dart';
import 'package:budgy/ui/screens/home/dashboard_screen.dart';
import 'package:budgy/ui/screens/expenses/expenses_screen.dart';
import 'package:budgy/ui/screens/income/incomes_screen.dart';
import 'package:budgy/ui/screens/savings/savings_screen.dart';
import 'package:budgy/ui/screens/settings/settings_screen.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key, this.currentIndex = 0});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      currentIndex: currentIndex,
      onTap: (i) {
        if (i == currentIndex) return;

        Widget screen;
        switch (i) {
          case 0:
            screen = const DashboardScreen();
            break;
          case 1:
            screen = const SavingsScreen();
            break;
          case 2:
            screen = const IncomesScreen();
            break;
          case 3:
            screen = const ExpensesScreen();
            break;
          case 4:
          default:
            screen = const SettingsScreen();
        }

        // Use the existing context here, NOT _
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.savings_outlined),
          activeIcon: Icon(Icons.savings),
          label: "Goals",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.paid_outlined),
          activeIcon: Icon(Icons.paid),
          label: "Income",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payments_outlined),
          activeIcon: Icon(Icons.payments),
          label: "Expenses",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: "Settings",
        ),
      ],
    );
  }
}
