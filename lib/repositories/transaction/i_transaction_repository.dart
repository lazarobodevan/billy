import 'package:billy/models/transaction/transaction_model.dart';

abstract class ITransactionRepository {
  Future<Transaction> create(Transaction transaction);

  Future<Transaction> update(Transaction transaction);

  Future<void> delete(int id);

  Future<List<Transaction>> getAll();

  Future<Map<DateTime, List<Transaction>>> getAllGroupedByDate({
    int limit = 10,
    int offset = 0,
  });

  Future<List<String>> getAvailablePeriods();

  Future<Transaction?> getById(id);
}
