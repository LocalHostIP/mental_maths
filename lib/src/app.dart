import 'package:flutter/material.dart';
import 'package:mental_maths/src/config.dart';
import 'package:mental_maths/src/math_op/saving.dart';
import 'package:mental_maths/src/screens/all_results_page.dart';
import 'package:mental_maths/src/screens/current_selected_archived_page.dart';
import 'package:mental_maths/src/screens/select_archived_page.dart';
import 'package:mental_maths/src/screens/config_levels.dart';
import 'package:mental_maths/src/screens/start_train_page.dart';
import 'package:mental_maths/src/screens/train_page.dart';
import 'package:mental_maths/src/screens/train_results_page.dart';

class MyApp extends StatelessWidget {//ignore: must_be_immutable
  TrainingSettings tSettings = new TrainingSettings(); //Controls training settings
  Savings savings = new Savings(); //Controls savings and file savings
  CurrentSelected currentSelected = new CurrentSelected();

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
      initialRoute: '/startTrain',
      routes: {
        '/startTrain': (BuildContext context) =>
            StartTrainPage(tSettings: tSettings),
        '/trainer': (BuildContext context) =>
            TrainPage(tSettings: tSettings, savings: savings),
        '/resultsPage': (BuildContext context) =>
            TrainResultsPage(results: savings.save),
        '/allResultsPage': (BuildContext context) =>
            AllResultsPage(savings: savings),
        '/configLevels': (BuildContext context) =>
            ConfigLevelsPage(tSettings: tSettings),
        '/archived':(BuildContext context) =>
            SelectArchivedPage(save: savings.save,currentSelected: currentSelected),
        '/selectedArchived' : (BuildContext context) =>
            SelectedArchivePage(archived: currentSelected.currentArchived,saving: savings)
      },
    );
  }
}
