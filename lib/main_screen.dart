import 'package:flutter/material.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/inventory/presentation/screens/inventory_screen.dart';
import 'features/transactions/presentation/screens/transaction_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionListScreen(),
    const InventoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.attach_money),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
        ],
      ),
    );
  }
}
