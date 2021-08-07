import 'dart:convert';
import 'dart:io';
import 'package:mental_maths/src/math_op/results.dart';
import 'package:path_provider/path_provider.dart';

class Savings{
  Results results = new Results();

  Future<void> printContent() async{
    var content = await readResults();
    print(content);
  }

  Future<void> iniResults() async{
    //var path = await _localPath;
    //print(path);
    results=await readResults();
    await validateFile();
    print(results.addition[1].recordV2);
    print(results.addition[1].recordV3);
    print(results.addition[1].lastPromV2);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/results.json');
  }

  Future<File> writeResults() async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(json.encode(results.toJson()));
  }

  Future<Results> readResults() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()){
        print('Creating file');
        await writeResults();
      }
      // Read the file
      final contents = await file.readAsString();
      return Results.fromJson(jsonDecode(contents));
    } catch (e) {
      print(e.toString());
      final file = await _localFile;
      await writeResults();
      final contents = await file.readAsString();
      return Results.fromJson(jsonDecode(contents));
    }
  }

  Future<void> validateFile() async{
    if (results.updateFile==null || results.updateFile<Results.updateFileCode){
      results=new Results();
      await writeResults();
      print('Recreating results');
    }
  }
}
