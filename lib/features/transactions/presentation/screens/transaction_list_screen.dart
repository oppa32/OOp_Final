import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import 'add_transaction_screen.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: transactions.isEmpty
          ? const Center(child: Text("No transactions yet."))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                // Show newest first
                final transaction =
                    transactions[transactions.length - 1 - index];
                final isExpense = transaction.type == 'expense';

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isExpense
                          ? Colors.red[100]
                          : Colors.green[100],
                      child: Icon(
                        isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isExpense ? Colors.red : Colors.green,
                      ),
                    ),
                    title: Text(
                      transaction.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
                    trailing: Text(
                      '₱${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isExpense ? Colors.red : Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    onLongPress: () {
                      // Simple delete confirmation
                      ref
                          .read(transactionProvider.notifier)
                          .deleteTransaction(transaction.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}
