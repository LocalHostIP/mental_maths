import 'package:flutter/material.dart';
import 'package:mental_maths/src/config.dart';
import 'package:mental_maths/src/math_op/math_problems.dart';
import 'package:mental_maths/src/saving.dart';
import 'package:mental_maths/src/screens/all_results_page.dart';
import 'package:mental_maths/src/screens/config_levels.dart';
import 'package:mental_maths/src/screens/start_train_page.dart';
import 'package:mental_maths/src/screens/train_page.dart';
import 'package:mental_maths/src/screens/train_results_page.dart';

import 'math_op/operation.dart';

class MyApp extends StatelessWidget {//ignore: must_be_immutable
  TrainingSettings tSettings = new TrainingSettings();
  Savings savings = new Savings();
  List<Operation> op = []; //Initial record operations, only for test
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
        '/startTrain':(BuildContext context) => StartTrainPage(tSettings: tSettings),
        '/trainer':(BuildContext context) => TrainPage(tSettings: tSettings,savings: savings),
        '/resultsPage':(BuildContext context) => TrainResultsPage(results: savings.results),
        '/allResultsPage':(BuildContext context) => AllResultsPage(savings: savings),

        '/configLevels':(BuildContext context) => ConfigLevelsPage(tsettigns: tSettings),
      },
    );
  }

  void iniResults() async{
    /// Reads records file ///
    op=[
      Operation.result(operator: MathProblems.OPSum,time: 5000,level: 2),
      Operation.result(operator: MathProblems.OPSum,time: 4000,level: 2),
      Operation.result(operator: MathProblems.OPSum,time: 300,level: 2),
      Operation.result(operator: MathProblems.OPSum,time: 2000,level: 2),
      Operation.result(operator: MathProblems.OPSub,time: 3000,level: 2),
      Operation.result(operator: MathProblems.OPSub,time: 4000,level: 1)
    ];
    
    //results.updateRegister([Operation.result(operator: MathProblem.OPRest, time: 1000, level: 2),
      //Operation.result(operator: MathProblem.OPRest, time: 5000, level: 1)]);
    //results.updateRegister(op);
    //savings.writeResults(results).whenComplete((){print('saved');});

    //results= await savings.readResults().whenComplete((){print('Results readed');});
    //print(results.addition[3].promTotal);

    savings.iniResults();

    //for(Operation o in results.addition[2].history){
    //  print(o.time);
    //}
  }
}
