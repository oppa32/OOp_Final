import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Ensure this path is correct:
import 'core/services/hive_registry.dart';
import 'core/theme/app_theme.dart';
import 'main_screen.dart';

void main() async {
  // ... rest of code
  // Ensure Flutter binding is initialized before Hive
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register adapters
  await HiveRegistry.init();

  runApp(
    // ProviderScope is required for Riverpod to work
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NavalBiz Tracker',
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
