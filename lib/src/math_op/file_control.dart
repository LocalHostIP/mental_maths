import 'dart:convert';
import 'dart:io';

import 'package:mental_maths/src/config.dart';
import 'package:mental_maths/src/math_op/save.dart';
import 'package:path_provider/path_provider.dart';


///data/user/0/com.dlocalp.mental_maths/app_flutter

class FileControl {
  ///Controls results savings and file for saving
  Save save = new Save();
  Settings settings = new Settings();
  
  String nameResultsFile = '/results.json';
  String nameConfigFile = '/config.json';
  
  Future<void> iniResults() async {
    ///Reads and validates results save
    save = await readResults();
    await validateResults();
  }

  Future<void> iniConfig() async{
    settings = await readConfig();
  }

  Future<String> get _localPath async {
    ///Returns default path for the saving file
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> _localFile(String name) async {
    ///Returns file for saving
    final path = await _localPath;
    return File('$path'+name);
  }

  Future<File> saveResults() async {
    ///Save on file
    final file = await _localFile(nameResultsFile);
    return file.writeAsString(json.encode(save.toJson()));
  }

  Future<File> saveConfig() async {
    print('saving config file');
    ///Save on file
    final file = await _localFile(nameConfigFile);
    return file.writeAsString(json.encode(settings.toJson()));
  }

  Future<Save> readResults() async {
    ///Read save file results
    try {
      final file = await _localFile(nameResultsFile);
      if (!file.existsSync()) {
        //If file don't exist create
        print('Creating results file');
        await saveResults();
      }
      // Read the file
      final contents = await file.readAsString();
      return Save.fromJson(jsonDecode(contents));
    } catch (e) {
      print('error on reading resulst file');
      print(e.toString());
      final file = await _localFile(nameResultsFile); //Create file if error
      await saveResults();
      final contents = await file.readAsString();
      return Save.fromJson(jsonDecode(contents));
    }
  }

  Future<Settings> readConfig() async {
    ///Read save file results
    try {
      final file = await _localFile(nameConfigFile);
      if (!file.existsSync()) {
        //If file don't exist create
        print('Creating config file');
        await saveConfig();
      }
      // Read the file
      final contents = await file.readAsString();
      return Settings.fromJson(jsonDecode(contents));
    } catch (e) {
      print(e.toString());
      //Create file if error
      final file = await _localFile(nameConfigFile);
      await saveConfig();
      final contents = await file.readAsString();
      return Settings.fromJson(jsonDecode(contents));
    }
  }

  Future<void> validateResults() async {
    ///Validates save from file
    if (save.updateFile == null ||
        save.updateFile < Save.updateFileCode) {
      save = new Save();
      await saveResults();
      print('Recreating results');
    }
  }
}
