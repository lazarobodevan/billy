import 'dart:io';

import 'package:billy/interfaces/i_external_backup.dart';
import 'package:billy/repositories/database_helper.dart';
import 'package:billy/services/google_drive_service/google_drive_service.dart';

class GoogleDriveBackupAndRestore implements IExternalBackup{

  final GoogleDriveService googleDriveService = GoogleDriveService();

  @override
  Future<void> backupDatabase() async{
    try {
      final dbHelper = DatabaseHelper();
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
  Future<void> restoreDatabase() async{
    final isAuthenticated = await googleDriveService.authenticate();
    if (isAuthenticated != null) {
      await googleDriveService.restoreDatabase('meu_banco.db');
    }
  }

}