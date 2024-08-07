import 'package:billy/transaction/models/transaction_model.dart';

abstract class ITransactionRepository{

  Future<Transaction> create(Transaction transaction);
  Future<Transaction> update(Transaction transaction);
  Future<Transaction> delete(int id);
  Future<List<Transaction>> getAll();
}