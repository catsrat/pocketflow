import '../db/database_helper.dart';
import '../models/expense.dart';
import '../models/expense.dart' as m;
import '../models/expense.dart';
import '../models/expense.dart';

class ExpenseRepository {
  final dbHelper = DatabaseHelper.instance;
  Future<void> init() async => await dbHelper.database;
}
