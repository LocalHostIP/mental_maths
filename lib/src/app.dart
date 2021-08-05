
import 'package:flutter/material.dart';
import 'package:mental_maths/src/config.dart';
import 'package:mental_maths/src/problems_generator.dart';
import 'package:mental_maths/src/results.dart';
import 'package:mental_maths/src/screens/all_results_page.dart';
import 'package:mental_maths/src/screens/config_levels.dart';
import 'package:mental_maths/src/screens/start_train_page.dart';
import 'package:mental_maths/src/screens/train_page.dart';
import 'package:mental_maths/src/screens/train_results_page.dart';

class MyApp extends StatelessWidget {
  TrainingSettings tsettings = new TrainingSettings();
  Results results = new Results();
  List<Operation> op = [];
  // This widget is the root of your application.

  MyApp(){
    iniResults();
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
        '/trainer':(BuildContext context) => TrainPage(tsettigns: tsettings,results: results),
        '/startTrain':(BuildContext context) => StartTrainPage(tsettigns: tsettings),
        '/configLevels':(BuildContext context) => ConfigLevelsPage(tsettigns: tsettings),
        '/resultsPage':(BuildContext context) => TrainResultsPage(results: results),
        '/allResultsPage':(BuildContext context) => AllResultsPage(results: results)
      },
    );
  }

  void iniResults(){

    op=[
      Operation.result(operator: MathProblem.OPSum,time: 5000,level: 2),
      Operation.result(operator: MathProblem.OPSum,time: 4000,level: 2),
      Operation.result(operator: MathProblem.OPSum,time: 300,level: 2),
      Operation.result(operator: MathProblem.OPSum,time: 2000,level: 2),
      Operation.result(operator: MathProblem.OPRest,time: 3000,level: 2),
      Operation.result(operator: MathProblem.OPRest,time: 4000,level: 1)
    ];
    
    //results.updateRegister([Operation.result(operator: MathProblem.OPRest, time: 1000, level: 2),
      //Operation.result(operator: MathProblem.OPRest, time: 5000, level: 1)]);
    results.updateRegister(op);



    //for(Operation o in results.addition[2].history){
     // print(o.time);
    //}
  }
}
