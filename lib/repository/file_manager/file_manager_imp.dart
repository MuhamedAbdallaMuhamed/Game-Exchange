import 'dart:io';

import 'package:GM_Nav/config/game_constants.dart';
import 'dart:async';
import 'file_manager.dart';

class IFileManager extends FileManager {
  File file;

  @override
  Future<void> create() async {
    bool isFileExist = await File(GameConstants.FILEPATH).exists();
    if (isFileExist) {
      file = new File(GameConstants.FILEPATH);
    } else {
      file = await new File(GameConstants.FILEPATH).create(recursive: true);
    }
  }

  @override
  Future<void> write(String docID) async {
    await create();
    await file.writeAsString(docID.toString());
  }

  @override
  Future<String> read() async {
    await create();
    String docID = await file.readAsString();
    if (docID == null) return "";
    return docID;
  }
}
