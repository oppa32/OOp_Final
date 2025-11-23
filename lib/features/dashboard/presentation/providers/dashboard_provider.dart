import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../transactions/presentation/providers/transaction_provider.dart';

// Helper class for Dashboard Data
class DashboardSummary {
  final double totalIncome;
  final double totalExpense;
  final double netProfit;

  DashboardSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netProfit,
  });
}

// Provider that calculates totals automatically when transactions change
final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  // Watch the transaction list
  final transactions = ref.watch(transactionProvider);

  double income = 0;
  double expense = 0;

  for (var t in transactions) {
    if (t.type == 'income') {
      income += t.amount;
    } else {
      expense += t.amount;
    }
  }

  return DashboardSummary(
    totalIncome: income,
    totalExpense: expense,
    netProfit: income - expense,
  );
});
