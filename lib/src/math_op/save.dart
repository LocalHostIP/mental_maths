import 'package:mental_maths/src/math_op/archived.dart';
import 'package:mental_maths/src/math_op/math_problems.dart';

import 'operation.dart';
import 'operation_register.dart';

class Save {
  ///Contains and controls current save
  static double updateFileCode = 0.0002; //For controlling version of saves
  double updateFile = Save.updateFileCode;

  //All levels of operation, each position of the list is a corresponding level
  List<OperationRegister> resultsSum = [];
  List<OperationRegister> resultsSub = [];
  //Contains the newly updated levels of a operation, first item has addition, second subtraction
  List<List<int>> updated = [];
  //Contains the max level of an operation
  static int maxLevel = 10; //Current max level on operations (one more)

  late List<Archived> archivedSum;
  late List<Archived> archivedSub;
  
  Save.fromJson(Map<String, dynamic> json){
      ///Create save from save file (json)
    resultsSum = OperationRegister.readListFromJson(json['addition']);
    resultsSub = OperationRegister.readListFromJson(json['subtraction']);
    updateFile = json['updateFile'];
    archivedSum = Archived.readListFromJson(json['archivedSum']);
    archivedSub = Archived.readListFromJson(json['archivedSub']);
    validateDataForUpdates();
  }
  
  Map<String, dynamic> toJson() => {
      ///Encoding to json
        'addition': resultsSum,
        'subtraction': resultsSub,
        'updateFile': updateFile,
        'archivedSum': archivedSum,
        'archivedSub':archivedSub
      };

  Save() {
    //Initiate all levels on every operation.dart
    for (int l = 1; l <= maxLevel; l++) {
      resultsSum.add(OperationRegister(name: 'Addition', level: l - 1));
      resultsSub.add(OperationRegister(name: 'Subtraction', level: l - 1));
    }
    _restartUpdate();
    _restartArchived();
  }


  void validateDataForUpdates(){
    ///Reconstructs saves if updates
    //Adding extra levels
    if(resultsSub.length<maxLevel-1){
      for (int i=0;i<=maxLevel-resultsSub.length;i++){
        resultsSub.add(new OperationRegister(name: 'Subtraction', level: resultsSub.length+i-2));
      }
    }
    if(resultsSum.length<maxLevel-1){
      for (int i=0;i<=maxLevel-resultsSum.length;i++){
        resultsSum.add(new OperationRegister(name: 'Addition', level: resultsSum.length+i-2));
      }
    }
    if(archivedSub.length<maxLevel-1){
      for (int i=0;i<=maxLevel-resultsSub.length;i++){
        archivedSub.add(new Archived(MathProblems.OPSub, archivedSub.length+i));
      }
    }
    if(archivedSum.length<maxLevel-1){
      for (int i=0;i<=maxLevel-archivedSum.length;i++){
        archivedSum.add(new Archived(MathProblems.OPSum, archivedSum.length+i));
      }
    }

  }

  List<OperationRegister> getResultsListByType(String type){
    if(type==MathProblems.OPSum)
      return resultsSum;
    else
      return resultsSub;
  }
  
  List<Archived> getArchivesListByType(String type){
    if(type==MathProblems.OPSum)
      return archivedSum;
    else
      return archivedSub;
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
    
    var archives = getArchivesListByType(type)[level];
    var register = getResultsListByType(type)[level];
    
    if(register.isArchived){
      archives.bestsL1[archives.lastIndex]=register.recordL1;
      archives.bestsL2[archives.lastIndex]=register.recordL2;
      archives.averages[archives.lastIndex]=register.aveTotal;
      archives.totals[archives.lastIndex]=register.nTotal;

      if(archives.bestL1>register.recordL1 || archives.bestL1==0)
        archives.bestL1=register.recordL1;
      if(archives.bestL2>register.recordL2 || archives.bestL2==0)
        archives.bestL2=register.recordL2;
      if(archives.bestAve>register.aveTotal || archives.bestAve==0)
        archives.bestAve=register.aveTotal;
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
      resultsSum[i].updateLastProm();
    }
    //Update last prom for subtraction
    for (int i in updated[1]) {
      resultsSub[i].updateLastProm();
    }

    //Update average
    for (Problem op in operations) {
      if (op.operator == MathProblems.OPSum) {
        resultsSum[op.level].addOperation(op);
      } else if (op.operator == MathProblems.OPSub) {
        resultsSub[op.level].addOperation(op);
      }
    }

    //update record and archive
    for (int i in updated[0]) {
      resultsSum[i].updateRecords();
      if(resultsSum[i].isArchived)
        _updateArchive(MathProblems.OPSum, i);
    }
    for (int i in updated[1]) {
      resultsSub[i].updateRecords();
      if(resultsSub[i].isArchived)
        _updateArchive(MathProblems.OPSum, i);
    }

  }
  
  void saveToArchive(String type,int level){

    if (this.isValidSaveToArchive(type,level)){
      var archives = getArchivesListByType(type)[level];
      var register = getResultsListByType(type)[level];

      if (type==MathProblems.OPSub) {
        archives = archivedSub[level];
        register = resultsSub[level];
      }

      register.isArchived=true;

      archives.lastIndex+=1;
      archives.bestsL1.add(register.recordL1);
      archives.bestsL2.add(register.recordL2);
      archives.averages.add(register.aveTotal);
      archives.totals.add(register.nTotal);

      if(archives.bestL1>register.recordL1 || archives.bestL1==0)
        archives.bestL1=register.recordL1;
      if(archives.bestL2>register.recordL2 || archives.bestL2==0)
        archives.bestL2=register.recordL2;
      if(archives.bestAve>register.aveTotal || archives.bestAve==0)
        archives.bestAve=register.aveTotal;
    }
  }

  bool isValidSaveToArchive(String type, int level){

    var archives = getArchivesListByType(type)[level];
    var register = getResultsListByType(type)[level];

    //Validate
    if(register.nTotal<Save.nLast2 || archives.lastIndex>=Archived.nMax-1)
      return false;
    else
      return true;
  }

  void deleteLevel(String type, int level) {
    getResultsListByType(type)[level].restart();
  }

  void updateArchiveRecord(String type,int level){
    var archives = getArchivesListByType(type)[level];
    archives.updateRecords();
  }

  static final int nLast1 = 2;
  static final int nLast2 = 3;
}
