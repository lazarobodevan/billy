import 'package:billy/models/limit/limit_model.dart';

abstract class ILimitRepository{
  Future<LimitModel> create(LimitModel limit);
  Future<LimitModel> update(LimitModel limit);
  Future<void> delete (int id);
  Future<List<LimitModel>> getAll();
  Future<LimitModel?> getRecent();
  Future<LimitModel> getById(int id);
  Future<double> recalcValueByLimitId(int id);
}