import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final _service = TransactionService();
  late Future<List<Transaction>> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = _service.getTransactions();
  }

  Map<String, double> _buildTotals(List<Transaction> txns) {
    final map = <String, double>{};
    for (final t in txns) {
      if (t.isExpense) {
        map[t.category] = (map[t.category] ?? 0) + t.amount;
      }
    }
    // Sort descending so biggest slice is first
    final sorted = Map.fromEntries(
      map.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
    return sorted;
  }

  String _fmt(double amount) {
    String val = amount.toStringAsFixed(
      amount.truncateToDouble() == amount ? 0 : 2,
    );
    return val.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Overview')),
      body: FutureBuilder<List<Transaction>>(
        future: _transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return _buildContent(snapshot.data!);
        },
      ),
    );
  }

  // Each logical section becomes its own method
  Widget _buildContent(List<Transaction> txns) {
    final totals = _buildTotals(txns);
    if (totals.isEmpty)
      return const Center(child: Text('No expense data yet.'));

    final grandTotal = totals.values.fold(0.0, (a, b) => a + b);
    final entries = totals.entries.toList();

    return Column(
      children: [
        const SizedBox(height: 24),
        _buildChart(entries, grandTotal),
        _buildSummaryRow(grandTotal),
        const Divider(height: 1),
        Expanded(child: _buildLegend(entries, grandTotal)),
      ],
    );
  }

  Widget _buildChart(
    List<MapEntry<String, double>> entries,
    double grandTotal,
  ) {
    final sections = entries.asMap().entries.map((e) {
      final color = _sliceColors(context)[e.key % _sliceColors(context).length];
      final pct = e.value.value / grandTotal * 100;
      return PieChartSectionData(
        value: e.value.value,
        color: color,
        radius: 90,
        title: '${pct.toStringAsFixed(1)}%',
        titleStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.surface,
        ),
      );
    }).toList();

    return SizedBox(
      height: 260,
      child: PieChart(
        PieChartData(
          sections: sections,
          sectionsSpace: 3,
          centerSpaceRadius: 50,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(double grandTotal) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            'Total Expenses',
            style: TextStyle(
              fontSize: 13,
              color: colors.onSurface.withOpacity(0.6),
            ),
          ),
          const Spacer(),
          Text(
            _fmt(grandTotal),
            style: TextStyle(fontWeight: FontWeight.bold, color: colors.error),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(
    List<MapEntry<String, double>> entries,
    double grandTotal,
  ) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, i) => _buildLegendItem(entries[i], grandTotal, i),
    );
  }

  Widget _buildLegendItem(
    MapEntry<String, double> entry,
    double grandTotal,
    int i,
  ) {
    final colors = Theme.of(context).colorScheme;
    final color = _sliceColors(context)[i % _sliceColors(context).length];
    final pct = entry.value / grandTotal * 100;

    return ListTile(
      leading: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      title: Text(entry.key, style: const TextStyle(fontSize: 14)),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _fmt(entry.value),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '${pct.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 11,
              color: colors.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _sliceColors(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return [
      c.primary,
      c.secondary,
      c.tertiary,
      c.error,
      c.primaryContainer,
      c.secondaryContainer,
      c.tertiaryContainer,
      c.errorContainer,
    ];
  }
}
