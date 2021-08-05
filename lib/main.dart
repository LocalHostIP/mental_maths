import 'package:flutter/material.dart';
import 'package:mental_maths/src/app.dart';

//flutter build apk --no-sound-null-safety

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized(); //Necessary to read saving files
  runApp(MyApp());
}
