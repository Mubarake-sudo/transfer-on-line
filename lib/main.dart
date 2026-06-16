import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'models/models.dart';
import 'screens/step1_operator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const TransferOnLineApp());
}

class TransferOnLineApp extends StatelessWidget {
  const TransferOnLineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transfer On Line',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final List<Transaction> _transactions = List.from(sampleTransactions);

  void _addTransaction(Transaction transaction) {
    setState(() {
      _transactions.insert(0, transaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Step1OperatorScreen(onTransactionAdded: _addTransaction);
  }
}
