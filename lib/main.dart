import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'data/repository/expense_repository.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = ExpenseRepository();
  await repo.init();
  runApp(
    MultiProvider(
      providers: [Provider<ExpenseRepository>.value(value: repo)],
      child: const PocketFlowApp(),
    ),
  );
}

class PocketFlowApp extends StatelessWidget {
  const PocketFlowApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
