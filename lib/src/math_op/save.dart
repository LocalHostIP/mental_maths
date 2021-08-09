import 'package:mental_maths/src/math_op/archived.dart';
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
  static int maxLevel = 6; //Current max level on operations (one more)

  late List<Archived> archivedSum;
  late List<Archived> archivedSub;
  
  Save.fromJson(Map<String, dynamic> json){
      ///Create save from save file (json)
    addition = OperationRegister.readListFromJson(json['addition']);
    subtraction = OperationRegister.readListFromJson(json['subtraction']);
    updateFile = json['updateFile'];
    archivedSum = Archived.readListFromJson(json['archivedSum']);
    archivedSub = Archived.readListFromJson(json['archivedSub']);
  }
  
  Map<String, dynamic> toJson() => {
      ///Encoding to json
        'addition': addition,
        'subtraction': subtraction,
        'updateFile': updateFile,
        'archivedSum': archivedSum,
        'archivedSub':archivedSub
      };

  Save() {
    //Initiate all levels on every operation.dart
    for (int l = 1; l <= maxLevel; l++) {
      addition.add(OperationRegister(name: 'Addition', level: l - 1));
      subtraction.add(OperationRegister(name: 'Subtraction', level: l - 1));
    }
    _restartUpdate();
    _restartArchived();
  }

  List<OperationRegister> getListByType(String type){
    if(type==MathProblems.OPSum)
      return addition;
    else
      return subtraction;
  }

  void _restartUpdate(){
    updated=[];
    updated.add([]); //Addition
    updated.add([]); //subtraction
  }

  void _restartArchived(){
    archivedSum=[];
    archivedSub=[];
    for (int i=0;i<=maxLevel+1;i++){
      archivedSum.add(new Archived(MathProblems.OPSum, i));
      archivedSub.add(new Archived(MathProblems.OPSub, i));
    }
  }

  void _updateArchive(String type,int level){
    var archives = archivedSum;
    var register = addition[level];

    if (type==MathProblems.OPSub) {
      archives = archivedSub;
      register = subtraction[level];
    }
    if(register.isArchived){
      archives[level].bestsL1[archives[level].lastIndex]=register.recordL1;
      archives[level].bestsL2[archives[level].lastIndex]=register.recordL2;
      archives[level].averages[archives[level].lastIndex]=register.aveTotal;
      archives[level].totals[archives[level].lastIndex]=register.nTotal;

      if(archives[level].bestL1>register.recordL1 || archives[level].bestL1==0)
        archives[level].bestL1=register.recordL1;
      if(archives[level].bestL2>register.recordL2 || archives[level].bestL2==0)
        archives[level].bestL2=register.recordL2;
      if(archives[level].bestAve>register.aveTotal || archives[level].bestAve==0)
        archives[level].bestAve=register.aveTotal;
    }

  }

  void updateSave(List<Problem> operations) {
    ///Update save
    //Restart update
    _restartUpdate();
    for (Problem op in operations) {
      if (op.operator == MathProblems.OPSum) {
        if (!updated[0].contains(op.level))
          updated[0].add(op.level);
      } else if (op.operator == MathProblems.OPSub) {
        if (!updated[1].contains(op.level)) updated[1].add(op.level);
      }
    }

    //Update last prom for addition
    for (int i in updated[0]) {
      addition[i].updateLastProm();
    }
    //Update last prom for subtraction
    for (int i in updated[1]) {
      subtraction[i].updateLastProm();
    }

    //Update average
    for (Problem op in operations) {
      if (op.operator == MathProblems.OPSum) {
        addition[op.level].addOperation(op);
      } else if (op.operator == MathProblems.OPSub) {
        subtraction[op.level].addOperation(op);
      }
    }

    //update record and archive
    for (int i in updated[0]) {
      addition[i].updateRecords();
      if(addition[i].isArchived)
        _updateArchive(MathProblems.OPSum, i);
    }
    for (int i in updated[1]) {
      subtraction[i].updateRecords();
      if(subtraction[i].isArchived)
        _updateArchive(MathProblems.OPSum, i);
    }

  }
  
  void saveToArchive(String type,int level){
    if (this.isValidSaveToArchive(type,level)){
      var archives = archivedSum;
      var register = addition[level];

      if (type==MathProblems.OPSub) {
        archives = archivedSub;
        register = subtraction[level];
      }

      register.isArchived=true;

      archives[level].lastIndex+=1;
      archives[level].bestsL1.add(register.recordL1);
      archives[level].bestsL2.add(register.recordL2);
      archives[level].averages.add(register.aveTotal);
      archives[level].totals.add(register.nTotal);

      if(archives[level].bestL1>register.recordL1 || archives[level].bestL1==0)
        archives[level].bestL1=register.recordL1;
      if(archives[level].bestL2>register.recordL2 || archives[level].bestL2==0)
        archives[level].bestL2=register.recordL2;
      if(archives[level].bestAve>register.aveTotal || archives[level].bestAve==0)
        archives[level].bestAve=register.aveTotal;
    }
  }

  bool isValidSaveToArchive(String type, int level){
    var register = addition[level];
    var archives = archivedSum[level];
    if (type==MathProblems.OPSub) {
      archives = archivedSub[level];
      register = subtraction[level];
    }
    //Validate
    if(register.nTotal<Save.nLast2 || archives.lastIndex>=Archived.nMax-1)
      return false;
    else
      return true;
  }

  void deleteLevel(String type, int level) {
    if (type == MathProblems.OPSum) {
      addition[level].restart();
    } else if (type == MathProblems.OPSub) {
      subtraction[level].restart();
    }
  }

  void updateArchiveRecord(String type,int level){
    var archives = archivedSum[level];

    if (type==MathProblems.OPSub) {
      archives = archivedSub[level];
    }

    archives.updateRecords();
  }

  static int nLast1 = 10;
  static int nLast2 = 50;
}
