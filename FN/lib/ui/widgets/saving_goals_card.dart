import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SavingGoalsCard extends StatefulWidget {
  const SavingGoalsCard({super.key});

  @override
  State<SavingGoalsCard> createState() => _SavingGoalsCardState();
}

class _SavingGoalsCardState extends State<SavingGoalsCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              CircularPercentIndicator(
                radius: 40,
                lineWidth: 8,
                percent: 0.7,
                progressColor: Colors.green,
                backgroundColor: Colors.white,
                center: const Icon(Icons.directions_car, color: Colors.white),
              ),
              Text(
                "Saving on Goals",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Container(width: 1.5, height: 60, color: Colors.white),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.savings, color: Colors.white, size: 40),
                  SizedBox(width: 6),
                  Column(
                    children: [
                      Text(
                        "Revenue Last Week",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "200,000 Frw",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(width: 180, height: 1.5, color: Colors.white),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Icon(Icons.restaurant, color: Colors.white, size: 40),
                  SizedBox(width: 6),
                  Column(
                    children: [
                      Text(
                        "Food Last Week",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "200,000 Frw",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
