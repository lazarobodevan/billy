import 'package:billy/models/backup/backup_model.dart';

abstract class IExternalBackup{
  Future<void> backupDatabase()async {}
  Future<void> restoreDatabase(String database) async{}
  Future<List<BackupModel>?> listBackups()async{return [];}
}