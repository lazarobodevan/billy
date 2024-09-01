import 'package:billy/repositories/transaction/i_transaction_repository.dart';

class DeleteTransactionUseCase{

  final ITransactionRepository transactionRepository;

  const DeleteTransactionUseCase({required this.transactionRepository});

  Future<void> execute(int id)async{
    final foundTransaction = await transactionRepository.getById(id);
    if(foundTransaction == null) return;

    await transactionRepository.delete(id);
  }


}