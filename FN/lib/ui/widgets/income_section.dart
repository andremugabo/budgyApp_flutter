import 'package:flutter/material.dart';

class IncomeSection extends StatelessWidget {
  const IncomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Income",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _tabButton("Today", isSelected: true),
            _tabButton("This week"),
            _tabButton("This Month"),
          ],
        ),
        const SizedBox(height: 10),
        _incomeItem(Icons.work, "Salary", "18:27 - April 30", "800,000 Frw"),
        _incomeItem(
          Icons.card_giftcard,
          "Allowance",
          "18:27 - April 30",
          "800,000 Frw",
        ),
        _incomeItem(
          Icons.trending_up,
          "Investment",
          "18:27 - April 30",
          "800,000 Frw",
        ),
        _incomeItem(
          Icons.account_balance,
          "Interest",
          "18:27 - April 30",
          "800,000 Frw",
        ),
      ],
    );
  }
}

Widget _tabButton(String text, {bool isSelected = false}) {
  return Padding(
    padding: const EdgeInsets.only(right: 8),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

Widget _incomeItem(IconData icon, String title, String date, String amout) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        Text(amout, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
