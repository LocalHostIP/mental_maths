import 'package:flutter/material.dart';
import 'package:mental_maths/src/config.dart';
import 'package:mental_maths/src/math_op/saving.dart';
import 'package:mental_maths/src/screens/all_results_page.dart';
import 'package:mental_maths/src/screens/archived_page.dart';
import 'package:mental_maths/src/screens/config_levels.dart';
import 'package:mental_maths/src/screens/start_train_page.dart';
import 'package:mental_maths/src/screens/train_page.dart';
import 'package:mental_maths/src/screens/train_results_page.dart';

class MyApp extends StatelessWidget {//ignore: must_be_immutable
  TrainingSettings tSettings = new TrainingSettings(); //Controls training settings
  Savings savings = new Savings(); //Controls savings and file savings

  MyApp() {
    savings.iniResults(); //Reads file savings
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Maths',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/archived',
      routes: {
        '/startTrain': (BuildContext context) =>
            StartTrainPage(tSettings: tSettings),
        '/trainer': (BuildContext context) =>
            TrainPage(tSettings: tSettings, savings: savings),
        '/resultsPage': (BuildContext context) =>
            TrainResultsPage(results: savings.results),
        '/allResultsPage': (BuildContext context) =>
            AllResultsPage(savings: savings),
        '/configLevels': (BuildContext context) =>
            ConfigLevelsPage(tSettings: tSettings),
        '/archived':(BuildContext context) =>
            ArchivedPage()
      },
    );
  }
}
