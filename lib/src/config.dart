import 'package:mental_maths/src/problems_generator.dart';

class Config{
  TrainingSettings trainingSettings = new TrainingSettings();
}

class TrainingSettings{
  bool addition=true;
  bool subtraction=false;
  List<int> addLevels = [1];
  List<int> subLevels = [1]; //substraction levels
  String currentOPSettings=MathProblem.OPSum;
  int limitOP=10;

  List<String> getActiveOperators(){
    List<String> op = [];
    if (addition)
      op.add(MathProblem.OPSum);
    if (subtraction)
      op.add(MathProblem.OPRest);
    return op;
  }

  void setLevels(String op,List<int> lvl){
    if (op==MathProblem.OPSum)
      addLevels=lvl;
    else if (op==MathProblem.OPRest)
      subLevels=lvl;
  }

  List<int> getLevels(String op){
    if (op==MathProblem.OPSum)
      return addLevels;
    else if (op==MathProblem.OPRest)
      return subLevels;
    return [];
  }

}