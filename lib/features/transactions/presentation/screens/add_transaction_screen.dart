import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends ConsumerWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(title: const Text('New Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: formKey,
          child: ListView(
            children: [
              FormBuilderTextField(
                name: 'title',
                decoration: const InputDecoration(
                  labelText: 'Item Name / Description',
                ),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'amount',
                decoration: const InputDecoration(labelText: 'Amount (₱)'),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderDropdown<String>(
                name: 'type',
                initialValue: 'income',
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(
                    value: 'income',
                    child: Text('Income (Sale)'),
                  ),
                  DropdownMenuItem(
                    value: 'expense',
                    child: Text('Expense (Purchase)'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FormBuilderDateTimePicker(
                name: 'date',
                initialValue: DateTime.now(),
                inputType: InputType.date,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
              // --- NEW FIELDS FOR INVENTORY ---
              const SizedBox(height: 20),
              const Text(
                'Inventory Link (Required for Stock Changes)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'productId',
                decoration: const InputDecoration(
                  labelText: 'Product ID (Enter ID from Inventory)',
                ),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'quantity',
                decoration: const InputDecoration(
                  labelText: 'Quantity (Sold or Purchased)',
                ),
                keyboardType: TextInputType.number,
                // We don't use required validator here because not every expense/income involves inventory.
              ),
              // ---------------------------------
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.saveAndValidate() ?? false) {
                      final values = formKey.currentState!.value;

                      // Convert Product ID and Quantity safely
                      final productId = values['productId']?.isNotEmpty == true
                          ? values['productId']
                          : null;
                      final quantity = values['quantity']?.isNotEmpty == true
                          ? int.tryParse(values['quantity']!)
                          : null;

                      final newTransaction = TransactionModel(
                        id: const Uuid().v4(),
                        title: values['title'],
                        amount: double.parse(values['amount']),
                        date: values['date'],
                        type: values['type'],
                        // Pass new values
                        productId: productId,
                        quantity: quantity,
                      );

                      ref
                          .read(transactionProvider.notifier)
                          .addTransaction(newTransaction);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Transaction'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
