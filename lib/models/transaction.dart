class Transaction {
  final int id;
  final String merchant;
  final String category;
	final double amount;
  final bool isExpense;
  final DateTime date;
  final bool confirmed;

  Transaction({
    required this.id,
    required this.merchant,
		required this.amount,
    required this.category,
    required this.isExpense,
    required this.date,
    required this.confirmed,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    merchant: json['merchant'],
		amount: (json['amount'] as num).toDouble(),
    category: json['category'],
    isExpense: json['is_expense'],
    date: DateTime.parse(json['date']),
    confirmed: json['confirmed'],
  );
}

