import 'dart:io';

abstract class IFileService{
  Future<File?> openFile();
}