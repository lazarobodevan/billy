import 'dart:io';

import 'package:billy/services/file_service/i_file_service.dart';
import 'package:file_picker/file_picker.dart';

class FileService implements IFileService{

  @override
  Future<File?> openFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);

    if (result == null) {
      return null;
    }

    return File(result.files.single.path!);
  }

}