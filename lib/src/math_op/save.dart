import 'package:mental_maths/src/math_op/math_problems.dart';

import 'operation.dart';
import 'operation_register.dart';

class Save {
  ///Contains and controls current save
  static double updateFileCode = 0.0002; //For controlling version of saves
  double updateFile = Save.updateFileCode;

  //All levels of operation, each position of the list is a corresponding level
  List<OperationRegister> addition = [];
  List<OperationRegister> subtraction = [];
  //Contains the newly updated levels of a operation, first item has addition, second subtraction
  List<List<int>> updated = [];
  //Contains the max level of an operation
  static int maxLevel = 7; //Current max level on operations
  
  Save.fromJson(Map<String, dynamic> json)
      ///Create save from save file (json)
      : addition = OperationRegister.readListFromJson(json['addition']),
        subtraction = OperationRegister.readListFromJson(json['subtraction']),
        updateFile = json['updateFile'];

  Map<String, dynamic> toJson() => {
      ///Encoding to json
        'addition': addition,
        'subtraction': subtraction,
        'updateFile': updateFile
      };

  Save() {
    //Initiate all levels on every operation.dart
    for (int l = 1; l <= maxLevel; l++) {
      addition.add(OperationRegister(name: 'Addition', level: l - 1));
      subtraction.add(OperationRegister(name: 'Subtraction', level: l - 1));
    }
    _restartUpdate();
  }

  void updateSave(List<Problem> operations) {
    ///Update save
    //Restart update
    _restartUpdate();

    //Update last prom
    for (int i = 0; i < maxLevel; i++) {
      addition[i].updateLastProm();
      subtraction[i].updateLastProm();
    }

    //Update prom
    for (Problem op in operations) {
      if (op.operator == MathProblems.OPSum) {
        addition[op.level].addOperation(op);

        if (!updated[0].contains(op.level))
          updated[0].add(op.level);
      } else if (op.operator == MathProblems.OPSub) {
        subtraction[op.level].addOperation(op);
        if (!updated[1].contains(op.level)) updated[1].add(op.level);
      }
    }

    //Update records
    for (int i = 0; i < maxLevel; i++) {
      addition[i].updateRecords();
      subtraction[i].updateRecords();
    }

  }

  void _restartUpdate(){
    updated=[];
    updated.add([]); //Addition
    updated.add([]); //subtraction
  }

  void deleteLevel(String type, int level) {
    if (type == MathProblems.OPSum) {
      addition[level].restart();
    } else if (type == MathProblems.OPSub) {
      subtraction[level].restart();
    }
  }

  static int nv2 = 10;
  static int nv3 = 50;
}
