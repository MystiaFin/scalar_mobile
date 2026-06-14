import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class TransactionRow extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onChanged; // Tells the parent list to refresh

  const TransactionRow({
    super.key,
    required this.transaction,
    required this.onChanged,
  });

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food & drink':
        return Icons.restaurant_outlined;
      case 'transport':
        return Icons.directions_car_outlined;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      case 'health':
        return Icons.favorite_outline;
      case 'utilities':
        return Icons.bolt_outlined;
      case 'entertainment':
        return Icons.movie_outlined;
      case 'transfer':
        return Icons.swap_horiz_outlined;
      default:
        return Icons.receipt_outlined;
    }
  }

  String _formatAmount(double amount, bool isExpense) {
    String val = amount.toStringAsFixed(
      amount.truncateToDouble() == amount ? 0 : 2,
    );
    val = val.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return isExpense ? '-$val' : '+$val';
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EditTransactionSheet(
        transaction: transaction,
        onSave: () {
          Navigator.pop(context);
          onChanged();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // InkWell provides the ripple effect when clicked
    return InkWell(
      onTap: () => _showEditSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _iconForCategory(transaction.category),
                color: colors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.merchant,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.category,
                    style: TextStyle(
                      color: colors.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _formatAmount(transaction.amount, transaction.isExpense),
              style: TextStyle(
                color: transaction.isExpense ? colors.error : colors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Private Stateful Widget to handle the form state inside the bottom sheet
class _EditTransactionSheet extends StatefulWidget {
  final Transaction transaction;
  final VoidCallback onSave;

  const _EditTransactionSheet({
    required this.transaction,
    required this.onSave,
  });

  @override
  State<_EditTransactionSheet> createState() => _EditTransactionSheetState();
}

class _EditTransactionSheetState extends State<_EditTransactionSheet> {
  final _service = TransactionService();
  late String _category;
  late bool _isExpense;
	late bool _confirmed;
  late TextEditingController _descController;
  bool _isSaving = false;

  final List<String> _categories = [
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
    _category = widget.transaction.category;
    if (!_categories.contains(_category)) _category = 'other';
    _isExpense = widget.transaction.isExpense;
		_confirmed = widget.transaction.confirmed;
    _descController = TextEditingController(
      text: widget.transaction.description ?? '',
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSaving = true);
    try {
      await _service.updateTransaction(widget.transaction.id, {
        'category': _category,
        'is_expense': _isExpense,
        'description': _descController.text.trim(),
				'confirmed': _confirmed,
      });
      widget.onSave();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Edit ${widget.transaction.merchant}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: _categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (val) => setState(() => _category = val!),
          ),
          const SizedBox(height: 16),

          SwitchListTile(
            title: const Text('Is an Expense?'),
            subtitle: const Text('Turn off if this was money received'),
            value: _isExpense,
            onChanged: (val) => setState(() => _isExpense = val),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),

					CheckboxListTile(
            title: const Text('Save as default for this merchant'),
            subtitle: const Text('Updates past entries and trains the AI for future ones'),
            value: _confirmed,
            onChanged: (val) => setState(() => _confirmed = val!),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading, // Puts checkbox on the left
          ),

          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Description / Note',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _isSaving ? null : _submit,
            child: _isSaving
                ? const CircularProgressIndicator()
                : const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
