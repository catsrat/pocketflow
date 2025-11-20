import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/repository/expense_repository.dart';
import '../screens/add_expense_screen.dart';
import '../widgets/expense_tile.dart';
import '../widgets/category_chip.dart';
import '../../data/models/expense.dart';
import '../../core/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<Expense> recent = [];
  double todayTotal = 0.0;
  double monthTotal = 0.0;
  final NumberFormat currency = NumberFormat.simpleCurrency();
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadData();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final repo = Provider.of<ExpenseRepository>(context, listen: false);
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final endOfToday = startOfToday.add(const Duration(days: 1)).subtract(const Duration(milliseconds: 1));
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1).subtract(const Duration(milliseconds: 1));

    final t = await repo.getTotalForDateRange(startOfToday, endOfToday);
    final m = await repo.getTotalForDateRange(startOfMonth, endOfMonth);
    final rec = await repo.getRecentExpenses(limit: 50);

    setState(() {
      todayTotal = t;
      monthTotal = m;
      recent = rec;
    });
  }

  Future<void> _openAddExpense([Expense? edit]) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddExpenseScreen(),
    );

    if (result == true) await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = 180.0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('PocketFlow'), backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        children: [
          // gradient header background
          Container(
            height: headerHeight,
            decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
          ),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _loadData,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // animated hero card
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final t = Curves.easeOut.transform(_controller.value);
                        return Transform.translate(
                          offset: Offset(0, (1 - t) * 20),
                          child: Opacity(opacity: t, child: child),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [AppTheme.softShadow],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text('Spending', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                Text(currency.format(monthTotal), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 6),
                                Text('Today: ' + currency.format(todayTotal), style: const TextStyle(color: Colors.white70)),
                              ]),
                            ),
                            Container(
                              width: 74,
                              height: 74,
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.14), borderRadius: BorderRadius.circular(14)),
                              child: const Icon(Icons.pie_chart, color: Colors.white, size: 34),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // category chips
                    SizedBox(
                      height: 56,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(width: 4),
                            CategoryChip(name: 'All', color: const Color(0xFF00BFA6), selected: true, onTap: (){}),
                            const SizedBox(width: 8),
                            CategoryChip(name: 'Food', color: const Color(0xFFFF7043), onTap: (){}),
                            const SizedBox(width: 8),
                            CategoryChip(name: 'Transport', color: const Color(0xFF29B6F6), onTap: (){}),
                            const SizedBox(width: 8),
                            CategoryChip(name: 'Rent', color: const Color(0xFF8E24AA), onTap: (){}),
                            const SizedBox(width: 8),
                            CategoryChip(name: 'Shopping', color: const Color(0xFFFFB300), onTap: (){}),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // list header
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Recent', style: Theme.of(context).textTheme.titleMedium),
                      TextButton.icon(onPressed: _loadData, icon: const Icon(Icons.refresh), label: const Text('Refresh')),
                    ]),

                    const SizedBox(height: 8),

                    // recent list
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: recent.isEmpty
                            ? Center(child: Text('No expenses yet. Tap + to add one.', style: Theme.of(context).textTheme.bodyMedium))
                            : ListView.separated(
                                itemCount: recent.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 8),
                                itemBuilder: (context, idx) {
                                  final e = recent[idx];
                                  return Material(
                                    color: Colors.white,
                                    elevation: 0,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [AppTheme.softShadow]),
                                      child: ExpenseTile(expense: e, onTap: () => _openAddExpense(e)),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: Tween<double>(begin: 0.92, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut)),
        child: FloatingActionButton(
          onPressed: () => _openAddExpense(),
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }
}
