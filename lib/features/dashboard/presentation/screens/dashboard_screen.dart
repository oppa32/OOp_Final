import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('NavalBiz Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSummaryCard(
              'Net Profit',
              summary.netProfit,
              Colors.blue,
              isBig: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Income',
                    summary.totalIncome,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Expenses',
                    summary.totalExpense,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Placeholder for charts or recent activity
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Welcome to NavalBiz! Use the bottom navigation to manage transactions and inventory.",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    double amount,
    Color color, {
    bool isBig = false,
  }) {
    return Card(
      elevation: 4,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(isBig ? 24.0 : 16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: isBig ? 18 : 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '₱${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: isBig ? 32 : 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
