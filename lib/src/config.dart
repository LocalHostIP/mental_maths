import 'package:mental_maths/src/math_op/math_problems.dart';

class Config {
  TrainingSettings trainingSettings = new TrainingSettings();
}

class TrainingSettings {
  bool addition = true;
  bool subtraction = false;
  List<int> addLevels = [1];
  List<int> subLevels = [1]; //subtraction levels
  String currentOPSettings = MathProblems.OPSum;
  int limitOP = 10; //Amount of operations

  List<String> getActiveOperators() {
    List<String> op = [];
    if (addition) op.add(MathProblems.OPSum);
    if (subtraction) op.add(MathProblems.OPSub);
    return op;
  }

  void setLevels(String op, List<int> lvl) {
    if (op == MathProblems.OPSum)
      addLevels = lvl;
    else if (op == MathProblems.OPSub) subLevels = lvl;
  }

  List<int> getLevels(String op) {
    if (op == MathProblems.OPSum)
      return addLevels;
    else if (op == MathProblems.OPSub) return subLevels;
    return [];
  }
}
