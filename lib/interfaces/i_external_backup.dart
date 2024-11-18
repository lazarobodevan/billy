abstract class IExternalBackup{
  Future<void> backupDatabase()async {}
  Future<void> restoreDatabase() async{}
}