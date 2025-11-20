class Expense {
  final int? id;
  final double amount;
  final int categoryId;
  final String? note;
  final String paymentMethod;
  final DateTime createdAt;

  Expense({this.id, required this.amount, required this.categoryId, this.note, required this.paymentMethod, required this.createdAt});

  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'categoryId': categoryId,
    'note': note,
    'paymentMethod': paymentMethod,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Expense.fromMap(Map<String, dynamic> m) => Expense(
    id: m['id'] as int?,
    amount: (m['amount'] as num).toDouble(),
    categoryId: m['categoryId'] as int,
    note: m['note'] as String?,
    paymentMethod: m['paymentMethod'] as String? ?? 'Cash',
    createdAt: DateTime.parse(m['createdAt'] as String),
  );
}
