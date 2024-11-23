import 'dart:io';

import 'package:billy/interfaces/i_external_backup.dart';
import 'package:billy/models/backup/backup_model.dart';
import 'package:billy/repositories/database_helper.dart';
import 'package:billy/services/google_drive_service/google_drive_service.dart';

class GoogleDriveBackupAndRestore implements IExternalBackup{

  final GoogleDriveService googleDriveService = GoogleDriveService();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Future<void> backupDatabase() async{
    try {
      final dbDir = await dbHelper.getDbPath();
      final dbFile = File(dbDir);

      final isAuthenticated = await googleDriveService.authenticate();
      if (isAuthenticated != null) {
        await googleDriveService.backupDatabase(dbFile);
      }
    }catch(e){
      print(e);
      rethrow;
    }
  }

  @override
  Future<void> restoreDatabase(String database) async{
    final isAuthenticated = await googleDriveService.authenticate();
    if (isAuthenticated != null) {
      File? db = await googleDriveService.restoreDatabase(database);
      if(db != null){
        await dbHelper.restoreDatabaseFromFile(db);
      }
    }
  }

  @override
  Future<List<BackupModel>?> listBackups() async{
    final isAuthenticated = await googleDriveService.authenticate();
    if (isAuthenticated != null) {
      return await googleDriveService.listBackups();
    }
  }

}