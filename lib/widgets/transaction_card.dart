import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionRow extends StatelessWidget {
  final Transaction transaction;

  const TransactionRow({super.key, required this.transaction});

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food & drink':   return Icons.restaurant_outlined;
      case 'transport':      return Icons.directions_car_outlined;
      case 'shopping':       return Icons.shopping_bag_outlined;
      case 'health':         return Icons.favorite_outline;
      case 'entertainment':  return Icons.movie_outlined;
      default:               return Icons.receipt_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_iconForCategory(transaction.category), color: colors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.merchant,
                  style: TextStyle(color: colors.onSurface, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.category,
                  style: TextStyle(color: colors.onSurface.withOpacity(0.5), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
