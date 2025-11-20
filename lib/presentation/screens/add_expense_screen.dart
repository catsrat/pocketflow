import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/repository/expense_repository.dart';
import '../../data/models/expense.dart';
import '../../data/models/category.dart';
import '../../core/theme.dart';
import '../widgets/category_chip.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? editExpense;
  const AddExpenseScreen({this.editExpense, super.key});
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _selected = DateTime.now();
  Category? _selectedCategory;
  String _paymentMethod = 'Cash';
  List<Category> _categories = [];
  final _fmt = DateFormat.yMMMd().add_jm();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.editExpense != null) {
      _amountCtrl.text = widget.editExpense!.amount.toString();
      _noteCtrl.text = widget.editExpense!.note ?? '';
      _selected = widget.editExpense!.createdAt;
      _paymentMethod = widget.editExpense!.paymentMethod;
    }
  }

  Future<void> _loadCategories() async {
    final repo = Provider.of<ExpenseRepository>(context, listen: false);
    final cats = await repo.getCategories();
    setState(() {
      _categories = cats;
      if (cats.isNotEmpty) {
        _selectedCategory = widget.editExpense != null ? cats.firstWhere((c) => c.id == widget.editExpense!.categoryId, orElse: ()=>cats.first) : cats.first;
      }
    });
  }

  void _pickDate() async {
    final date = await showDatePicker(context: context, initialDate: _selected, firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days:365)));
    if (date == null) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_selected));
    if (time == null) return;
    setState(()=> _selected = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = Provider.of<ExpenseRepository>(context, listen: false);
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '').trim()) ?? 0.0;
    if (widget.editExpense != null) {
      final updated = Expense(
        id: widget.editExpense!.id,
        amount: amount,
        categoryId: _selectedCategory?.id ?? 1,
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        paymentMethod: _paymentMethod,
        createdAt: _selected,
      );
      await repo.updateExpense(updated);
    } else {
      final exp = Expense(
        amount: amount,
        categoryId: _selectedCategory?.id ?? 1,
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        paymentMethod: _paymentMethod,
        createdAt: _selected,
      );
      await repo.addExpense(exp);
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final inputStyle = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, sc) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(18)), boxShadow: [AppTheme.softShadow]),
              child: SingleChildScrollView(
                controller: sc,
                child: Form(
                  key: _formKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 48, height: 6, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(6))),
                    const SizedBox(height: 12),
                    Text(widget.editExpense != null ? 'Edit Expense' : 'Add Expense', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),

                    // Amount
                    TextFormField(
                      controller: _amountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: inputStyle.copyWith(prefixText: '₹ ', hintText: '0.00'),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                      validator: (v) {
                        if (v==null || v.trim().isEmpty) return 'Enter amount';
                        final n = double.tryParse(v.replaceAll(',', '').trim());
                        if (n==null || n<=0) return 'Enter valid amount';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Categories horizontal scroll
                    SizedBox(
                      height: 70,
                      child: _categories.isEmpty ? const SizedBox() : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, i) {
                          final c = _categories[i];
                          final color = _parseColor(c.colorHex ?? '#2196F3');
                          return CategoryChip(name: c.name, color: color, selected: _selectedCategory?.id==c.id, onTap: ()=> setState(()=> _selectedCategory = c));
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemCount: _categories.length,
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(controller: _noteCtrl, decoration: inputStyle.copyWith(hintText: 'Note (optional)')),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _pickDate,
                            child: InputDecorator(
                              decoration: inputStyle.copyWith(labelText: 'Date & Time'),
                              child: Text(_fmt.format(_selected)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _paymentMethod,
                          items: const [
                            DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                            DropdownMenuItem(value: 'Card', child: Text('Card')),
                            DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                          ],
                          onChanged: (v) { if (v!=null) setState(()=> _paymentMethod=v); },
                        )
                      ],
                    ),

                    const SizedBox(height: 18),

                    Row(children: [
                      Expanded(child: ElevatedButton(onPressed: _save, child: const Text('Save'))),
                    ]),

                    const SizedBox(height: 8),
                  ]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      var h = hex.replaceFirst('#', '');
      if (h.length == 6) h = 'FF$h';
      return Color(int.parse(h, radix: 16));
    } catch (_) {
      return const Color(0xFF2196F3);
    }
  }
}
