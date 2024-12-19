import 'dart:io';
import 'package:billy/models/backup/backup_model.dart';
import 'package:billy/services/auth_service/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import 'authenticated_client.dart';

class GoogleDriveService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope],
  );

  late drive.DriveApi _driveApi;
  final GoogleAuthService googleAuthService = GoogleAuthService();

  Future<http.Client?> authenticate() async {
    try {
      // Tenta fazer login silencioso primeiro
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signInSilently() ?? await _googleSignIn.signIn();

      print(googleUser);

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Cria um cliente autenticado
      final AuthClient authClient = authenticatedClient(
        http.Client(),
        AccessCredentials(
          AccessToken('Bearer', googleAuth.accessToken!,
              DateTime.now().add(Duration(hours: 1)).toUtc()),
          googleAuth.idToken,
          [drive.DriveApi.driveFileScope],
        ),
      );

      // Inicializa o Drive API
      _driveApi = drive.DriveApi(authClient);

      return authClient;
    } catch (e) {
      print('Erro na autenticação: $e');
      return null;
    }
  }

  http.Client authenticatedClientFromHeaders(Map<String, String> headers) {
    return AuthenticatedClient(http.Client(), headers);
  }

  Future<void> backupDatabase(File dbFile) async {
    try {
      final timestamp =
          DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final backupFileName = 'data_billy_$timestamp.db';

      String folderId = await _getOrCreateBackupFolder();


      final drive.File driveFile = drive.File();
      driveFile.name = backupFileName;
      driveFile.mimeType = 'application/x-sqlite3';
      driveFile.parents = [folderId];

      await _driveApi.files.create(
        driveFile,
        uploadMedia: drive.Media(dbFile.openRead(), dbFile.lengthSync()),
      );
      debugPrint('Backup realizado com sucesso no Google Drive.');
    } catch (e) {
      debugPrint('Erro ao fazer backup: $e');
    }
  }

  Future<String> _getOrCreateBackupFolder() async {
    try {
      const folderName = 'billy_backups';
      const mimeTypeFolder = 'application/vnd.google-apps.folder';

      // Procurar uma pasta com o nome 'billy_backups'
      const query =
          "mimeType='$mimeTypeFolder' and name='$folderName' and trashed=false";
      final response = await _driveApi.files.list(q: query);

      if (response.files != null && response.files!.isNotEmpty) {
        return response.files!.first.id!;
      }

      // Caso a pasta não exista, criar uma nova
      final drive.File folder = drive.File();
      folder.name = folderName;
      folder.mimeType = mimeTypeFolder;

      final createdFolder = await _driveApi.files.create(folder);
      debugPrint('Pasta billy_backups criada no Google Drive.');

      return createdFolder.id!;
    } catch (e) {
      debugPrint('Erro ao obter ou criar a pasta billy_backups: $e');
      throw Exception(
          'Não foi possível encontrar ou criar a pasta billy_backups.');
    }
  }

  Future<File?> restoreDatabase(String dbName) async {
    try {

      String folderId = await _getOrCreateBackupFolder();

      // Procurar pelo arquivo de backup no Google Drive
      final result = await _driveApi.files.list(
          q: "'$folderId' in parents and name contains '$dbName'",
          spaces: 'drive',
          $fields: 'files(id, name, modifiedTime)',
          orderBy: 'createdTime desc');

      if (result.files != null && result.files!.isNotEmpty) {
        final mostRecentFile = result.files!.first;
        final fileId = mostRecentFile.id;

        if (fileId != null) {
          // Baixar o arquivo mais recente
          final driveFile = await _driveApi.files.get(
            fileId,
            downloadOptions: drive.DownloadOptions.fullMedia,
          );

          final dir = await getApplicationDocumentsDirectory();
          final localFile = File(join(dir.path, 'data_billy.db'));

          final dataStream = driveFile as drive.Media;
          final bytes = await dataStream.stream.toList();
          File db =
              await localFile.writeAsBytes(bytes.expand((x) => x).toList());

          debugPrint(
              'Banco de dados restaurado com sucesso do arquivo: ${mostRecentFile.name}');
          return db;
        }
      } else {
        debugPrint('Nenhum arquivo de backup encontrado no Google Drive.');
      }
    } catch (e) {
      debugPrint('Erro ao restaurar: $e');
      rethrow;
    }
    return null;
  }

  Future<List<BackupModel>?> listBackups() async {
    try {
      String folderId = await _getOrCreateBackupFolder();

      // Procurar pelo arquivo de backup no Google Drive
      final result = await _driveApi.files.list(
          q: "'$folderId' in parents and name contains 'data_billy_'",
          spaces: 'drive',
          $fields: 'files(id, name, modifiedTime)',
          orderBy: 'createdTime desc');
      if (result.files != null && result.files!.isNotEmpty) {
        return result.files!.map((el) {
          return BackupModel(name: el.name!, date: el.modifiedTime!);
        }).toList();
      }
      return null;
    } catch (e) {
      debugPrint("Erro ao listar: $e");
      rethrow;
    }
  }
}
