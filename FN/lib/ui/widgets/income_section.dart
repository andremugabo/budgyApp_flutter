import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomeSection extends StatefulWidget {
  const IncomeSection({super.key});

  @override
  State<IncomeSection> createState() => _IncomeSectionState();
}

class _IncomeSectionState extends State<IncomeSection> with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late AnimationController _animationController;

  final List<String> _tabs = ["Today", "This Week", "This Month"];

  // Sample data - replace with actual data source
  final Map<String, List<IncomeItem>> _incomeData = {
    "Today": [
      IncomeItem(
        icon: Icons.work_rounded,
        title: "Salary",
        date: DateTime.now(),
        amount: 800000,
        category: "Employment",
        color: Colors.blue,
      ),
      IncomeItem(
        icon: Icons.card_giftcard_rounded,
        title: "Allowance",
        date: DateTime.now().subtract(const Duration(hours: 2)),
        amount: 50000,
        category: "Gift",
        color: Colors.purple,
      ),
    ],
    "This Week": [
      IncomeItem(
        icon: Icons.work_rounded,
        title: "Salary",
        date: DateTime.now(),
        amount: 800000,
        category: "Employment",
        color: Colors.blue,
      ),
      IncomeItem(
        icon: Icons.card_giftcard_rounded,
        title: "Allowance",
        date: DateTime.now().subtract(const Duration(hours: 2)),
        amount: 50000,
        category: "Gift",
        color: Colors.purple,
      ),
      IncomeItem(
        icon: Icons.trending_up_rounded,
        title: "Investment Returns",
        date: DateTime.now().subtract(const Duration(days: 3)),
        amount: 120000,
        category: "Investment",
        color: Colors.green,
      ),
    ],
    "This Month": [
      IncomeItem(
        icon: Icons.work_rounded,
        title: "Salary",
        date: DateTime.now(),
        amount: 800000,
        category: "Employment",
        color: Colors.blue,
      ),
      IncomeItem(
        icon: Icons.card_giftcard_rounded,
        title: "Allowance",
        date: DateTime.now().subtract(const Duration(hours: 2)),
        amount: 50000,
        category: "Gift",
        color: Colors.purple,
      ),
      IncomeItem(
        icon: Icons.trending_up_rounded,
        title: "Investment Returns",
        date: DateTime.now().subtract(const Duration(days: 3)),
        amount: 120000,
        category: "Investment",
        color: Colors.green,
      ),
      IncomeItem(
        icon: Icons.account_balance_rounded,
        title: "Bank Interest",
        date: DateTime.now().subtract(const Duration(days: 15)),
        amount: 15000,
        category: "Interest",
        color: Colors.orange,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_selectedTabIndex != index) {
      setState(() {
        _selectedTabIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  double _getTotalIncome() {
    final items = _incomeData[_tabs[_selectedTabIndex]] ?? [];
    return items.fold(0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _incomeData[_tabs[_selectedTabIndex]] ?? [];
    final totalIncome = _getTotalIncome();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_downward_rounded,
                        color: Colors.green.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Income",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total: ${_formatCurrency(totalIncome)}",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              // Add income button
              IconButton(
                onPressed: () {
                  // TODO: Implement add income
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add income coming soon')),
                  );
                },
                icon: Icon(
                  Icons.add_circle_rounded,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                tooltip: 'Add Income',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tab buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                _tabs.length,
                    (index) => Padding(
                  padding: EdgeInsets.only(right: index < _tabs.length - 1 ? 8 : 0),
                  child: _TabButton(
                    text: _tabs[index],
                    isSelected: _selectedTabIndex == index,
                    onTap: () => _onTabSelected(index),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Divider(color: theme.dividerColor.withOpacity(0.5)),

          const SizedBox(height: 8),

          // Income items list with animation
          if (items.isEmpty)
            _EmptyState(period: _tabs[_selectedTabIndex])
          else
            FadeTransition(
              opacity: _animationController,
              child: Column(
                children: List.generate(
                  items.length,
                      (index) => _IncomeItem(
                    item: items[index],
                    delay: Duration(milliseconds: index * 50),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: 'Frw ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}

// Income data model
class IncomeItem {
  final IconData icon;
  final String title;
  final DateTime date;
  final double amount;
  final String category;
  final Color color;

  IncomeItem({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.category,
    required this.color,
  });
}

// Tab button widget
class _TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? Colors.white
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Income item widget
class _IncomeItem extends StatefulWidget {
  final IncomeItem item;
  final Duration delay;

  const _IncomeItem({
    required this.item,
    this.delay = Duration.zero,
  });

  @override
  State<_IncomeItem> createState() => _IncomeItemState();
}

class _IncomeItemState extends State<_IncomeItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
            onTap: () {
              // TODO: Show transaction details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('View details: ${widget.item.title}')),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.dividerColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: widget.item.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.item.icon,
                      color: widget.item.color,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Title and date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(widget.item.date),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: widget.item.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.item.category,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: widget.item.color,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatCurrency(widget.item.amount),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(date);
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(date);
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: 'Frw ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}

// Empty state widget
class _EmptyState extends StatelessWidget {
  final String period;

  const _EmptyState({required this.period});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 40,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No income for $period',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first income entry',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}