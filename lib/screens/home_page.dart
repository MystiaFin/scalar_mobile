import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../models/transaction.dart';
import '../widgets/transaction_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _service = TransactionService();
  late Future<List<Transaction>> _transactions;

  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  final Set<String> _selectedCategories = {};

  static const _allCategories = [
    'food & drink',
    'transport',
    'utilities',
    'entertainment',
    'shopping',
    'health',
    'transfer',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _transactions = _service.getTransactions();
  }

  List<DateTime> get _months => List.generate(
        12,
        (i) => DateTime(DateTime.now().year, DateTime.now().month - i),
      );

  String _formatMonth(DateTime dt) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${names[dt.month - 1]} ${dt.year}';
  }

  String _formatDate(DateTime date) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${names[date.month - 1]} ${date.day}, ${date.year}';
  }

  List<Transaction> _applyFilters(List<Transaction> txns) {
    return txns.where((t) {
      final matchesMonth = t.date.year == _selectedMonth.year &&
          t.date.month == _selectedMonth.month;
      final matchesCategory = _selectedCategories.isEmpty ||
          _selectedCategories.contains(t.category.toLowerCase());
      return matchesMonth && matchesCategory;
    }).toList();
  }

  Map<String, List<Transaction>> _groupByDate(List<Transaction> txns) {
    final grouped = <String, List<Transaction>>{};
    for (final t in txns) {
      grouped.putIfAbsent(_formatDate(t.date), () => []).add(t);
    }
    return grouped;
  }

  void _openCategoryFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
                child: Row(
                  children: [
                    const Text(
                      'Filter by Category',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setSheetState(() {});
                        setState(() => _selectedCategories.clear());
                      },
                      child: const Text('Clear all'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              for (final cat in _allCategories)
                CheckboxListTile(
                  title: Text(cat),
                  value: _selectedCategories.contains(cat),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (checked) {
                    setSheetState(() {
                      setState(() {
                        checked! 
                          ? _selectedCategories.add(cat)
                          : _selectedCategories.remove(cat);
                      });
                    });
                  },
                ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(String label) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: colors.onSurface.withOpacity(0.25),
          ),
          const SizedBox(height: 12),
          Text(
            'No transactions found',
            style: TextStyle(color: colors.onSurface.withOpacity(0.45)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilter = _selectedCategories.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<DateTime>(
          value: _selectedMonth,
          underline: const SizedBox(),
          icon: const Icon(Icons.expand_more),
          style: Theme.of(context).textTheme.titleLarge,
          items: _months
              .map((m) => DropdownMenuItem(value: m, child: Text(_formatMonth(m))))
              .toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedMonth = val);
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Filter by category',
            icon: Badge(
              isLabelVisible: hasActiveFilter,
              label: Text('${_selectedCategories.length}'),
              child: const Icon(Icons.filter_list),
            ),
            onPressed: _openCategoryFilter,
          ),
        ],
      ),
      body: FutureBuilder<List<Transaction>>(
        future: _transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }

          final filtered = _applyFilters(snapshot.data!);
          if (filtered.isEmpty) return _buildEmptyState();

          final grouped = _groupByDate(filtered);

          return ListView(
            children: [
              for (final entry in grouped.entries) ...[
                _buildDateHeader(entry.key),
                for (final t in entry.value)
                  TransactionRow(
                    transaction: t,
                    onChanged: () => setState(() {
                      _transactions = _service.getTransactions();
                    }),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}
