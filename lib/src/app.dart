import 'package:flutter/material.dart';
import 'package:mental_maths/src/config.dart';
import 'package:mental_maths/src/file_control.dart';
import 'package:mental_maths/src/ranking/ranking_save.dart';
import 'package:mental_maths/src/screens/config/keyboard_size_page.dart';
import 'package:mental_maths/src/screens/rankings/raking_page.dart';
import 'package:mental_maths/src/screens/training/all_results_page.dart';
import 'package:mental_maths/src/screens/archive/current_selected_archived_page.dart';
import 'package:mental_maths/src/screens/config/general_config_page.dart';
import 'package:mental_maths/src/screens/archive/select_archived_page.dart';
import 'package:mental_maths/src/screens/training/config_levels.dart';
import 'package:mental_maths/src/screens/training/start_train_page.dart';
import 'package:mental_maths/src/screens/training/train_page.dart';
import 'package:mental_maths/src/screens/training/train_results_page.dart';

class MyApp extends StatelessWidget {//ignore: must_be_immutable
  TrainingSettings trainSettings = new TrainingSettings(); //Controls training settings
  FileControl fileControl = new FileControl(); //Controls savings and file savings
  CurrentSelected currentSelected = new CurrentSelected();
  late DatabaseCache dtCache;

  MyApp() {
    fileControl.iniResults(); //Reads file savings
    fileControl.iniConfig();
    fileControl.iniRank();
    dtCache=new DatabaseCache(fileControl.save);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mental Maths',

      themeMode: ThemeMode.system,

      initialRoute: '/startTrain',
      routes: {
        '/startTrain': (BuildContext context) =>
            StartTrainPage(tSettings: trainSettings),
        '/trainer': (BuildContext context) =>
            TrainPage(trainSettings: trainSettings, savings: fileControl,settings: fileControl.settings,rankingSave: fileControl.rankingSave,),
        '/resultsPage': (BuildContext context) =>
            TrainResultsPage(results: fileControl.save),
        '/allResultsPage': (BuildContext context) =>
            AllResultsPage(savings: fileControl),
        '/configLevels': (BuildContext context) =>
            ConfigLevelsPage(tSettings: trainSettings),
        '/archived':(BuildContext context) =>
            SelectArchivedPage(save: fileControl.save,currentSelected: currentSelected),
        '/selectedArchived' : (BuildContext context) =>
            SelectedArchivePage(archived: currentSelected.currentArchived,saving: fileControl),
        '/config' : (BuildContext context) =>
            ConfigPage(fileControl: fileControl,rankingSave: fileControl.rankingSave,),
        '/config/keyboardSize': (BuildContext context) =>
            KeyboardSizePage(fileControl: fileControl),
        '/ranking': (BuildContext context) =>
            RankingPage(rankingSave: fileControl.rankingSave,fileControl: fileControl,dtCache: dtCache),
      },
    );
  }
}
