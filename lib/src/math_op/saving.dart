import 'dart:convert';
import 'dart:io';

import 'package:mental_maths/src/math_op/save.dart';
import 'package:path_provider/path_provider.dart';

class Savings {
  ///Controls results savings and file for saving
  Save save = new Save();
  
  Future<void> iniResults() async {
    ///Reads and validates results save
    save = await readFile();
    await validateFile();
  }

  Future<String> get _localPath async {
    ///Returns default path for the saving file
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    ///Returns file for saving
    final path = await _localPath;
    return File('$path/results.json');
  }

  Future<File> writeFile() async {
    ///Save on file
    final file = await _localFile;
    return file.writeAsString(json.encode(save.toJson()));
  }

  Future<Save> readFile() async {
    ///Read save file
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        //If file don't exist create
        print('Creating file');
        await writeFile();
      }
      // Read the file
      final contents = await file.readAsString();
      return Save.fromJson(jsonDecode(contents));
    } catch (e) {
      print(e.toString());
      final file = await _localFile; //Create file if error
      await writeFile();
      final contents = await file.readAsString();
      return Save.fromJson(jsonDecode(contents));
    }
  }

  Future<void> validateFile() async {
    ///Validates save from file
    if (save.updateFile == null ||
        save.updateFile < Save.updateFileCode) {
      save = new Save();
      await writeFile();
      print('Recreating results');
    }
  }
}
