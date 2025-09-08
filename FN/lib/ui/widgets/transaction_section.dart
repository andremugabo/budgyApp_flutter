import 'package:flutter/material.dart';

class TransactionItem {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final Map<String, dynamic>? extra;

  TransactionItem({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    this.extra,
  });
}

class TransactionSection extends StatelessWidget {
  final String sectionTitle;
  final Color color;
  final List<TransactionItem> items;
  final void Function(TransactionItem)? onItemLongPress;

  const TransactionSection({
    super.key,
    required this.sectionTitle,
    required this.color,
    required this.items,
    this.onItemLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.category, color: color),
            const SizedBox(width: 8),
            Text(
              sectionTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
          ],
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
        const SizedBox(height: 12),
        ...items.map((item) => _transactionItem(item)).toList(),
      ],
    );
  }

  Widget _tabButton(String text, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.shade200,
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

  Widget _transactionItem(TransactionItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(item.icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onLongPress: onItemLongPress == null ? null : () => onItemLongPress!(item),
            child: Text(
              item.amount,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
