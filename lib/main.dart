import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mental_maths/src/app.dart';

//flutter build apk --no-sound-null-safety
//com.dlocalp.mental_maths

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Necessary to read saving files

  Firebase.initializeApp().then((value){
    runApp(MyApp());
  });
}
