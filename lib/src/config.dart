
import 'package:mental_maths/src/math_op/archived.dart';
import 'package:mental_maths/src/math_op/math_problems.dart';

class CurrentSelected{
  Archived currentArchived = new Archived(MathProblems.OPSum, 1);
}

class Settings{
  double keyboardWidth=90;
  double keyboardHeight=30;
  double extraTime=0;

  Map<String, dynamic> toJson() => {
    ///Encoding to json
    'keyboardWidth': keyboardWidth,
    'keyboardHeight': keyboardHeight,
    'extraTime': extraTime,
  };

  Settings.fromJson(Map<String,dynamic> json){
    keyboardWidth = json['keyboardWidth'];
    keyboardHeight = json['keyboardHeight'];
    extraTime = json['extraTime'];
  }

  Settings();
}

class TrainingSettings {
  ///Contains configuration for next training (Type of operation and levels)
  bool addition = true; //Is addition on next training
  bool subtraction = false; //Is subtraction on next training
  String currentOPSettings = MathProblems.OPSum; //Current Type of operation on config page
  int limitOP = 10; //Amount of operations

  List<int> _addLevels = [1]; //Addition levels on next train
  List<int> _subLevels = [1]; //subtraction levels on next train

  List<String> getActiveOperators() {
    /// Returns all type of operations for next training 
    List<String> op = [];
    if (addition) op.add(MathProblems.OPSum);
    if (subtraction) op.add(MathProblems.OPSub);
    return op;
  }

  void setLevels(String typeOperation, List<int> lvl) {
    ///Set levels for next training 
    if (typeOperation == MathProblems.OPSum)
      _addLevels = lvl;
    else if (typeOperation == MathProblems.OPSub) 
      _subLevels = lvl;
  }

  List<int> getLevels(String typeOperation) {
    ///Returns levels for
    if (typeOperation == MathProblems.OPSum)
      return _addLevels;
    else if (typeOperation == MathProblems.OPSub)
      return _subLevels;
    return [];
  }

}
