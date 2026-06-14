import '../models/transaction.dart';
import 'api_client.dart';

class TransactionService {
  final _client = ApiClient();

  Future<List<Transaction>> getTransactions() async {
    final data = await _client.get('/api/transactions') as List;
    return data.map((json) => Transaction.fromJson(json)).toList();
  }

  Future<void> updateTransaction(int id, Map<String, dynamic> data) async {
    await _client.patch('/api/transactions/$id', data);
  }
}
