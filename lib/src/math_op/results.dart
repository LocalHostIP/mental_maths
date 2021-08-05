import 'package:mental_maths/src/math_op/math_problems.dart';

import 'operation.dart';
import 'operation_register.dart';

class Results{
  List<OpRegister> addition  = [];
  List<OpRegister> subtraction  = []; //All levels of substraction, each position of the list is a corresponding level
  List<List<int>> updated = []; //Contains the newly updated levels
  int maxLevel = 7; //Current max level on operations

  Results.fromJson(Map<String,dynamic> json):
    addition = OpRegister.readListFromJson(json['addition']),
    subtraction = OpRegister.readListFromJson(json['subtraction']);

  Map <String,dynamic> toJson() =>
    {
      'addition':addition,
      'subtraction':subtraction,
    };

  Results(){
    //Initiate all levels on every operation.dart
    for (int l = 1;l<=maxLevel;l++){
      addition.add(OpRegister(name:'Addition',level:l-1));
      subtraction.add(OpRegister(name:'Subtraction',level:l-1));
    }
    //Initiate updated
    updated.add([]); //Addition
    updated.add([]); //subtraction
  }

  void updateRegister(List<Operation> operations){
    //Restart update
    updated=[[],[]];

    //Update last prom
    for (int i = 0;i<maxLevel;i++){
      addition[i].updateLastProm();
      subtraction[i].updateLastProm();
    }

    //Update prom
    for (Operation op in operations){
      if (op.operator==MathProblems.OPSum){
        addition[op.level].addOperation(op);

        if (!updated[0].contains(op.level))
          updated[0].add(op.level);
      }
      else if(op.operator==MathProblems.OPSub){
        subtraction[op.level].addOperation(op);
        if (!updated[1].contains(op.level))
          updated[1].add(op.level);
      }
    }
  }

  void deleteLevel(String type, int level){
    if (type==MathProblems.OPSum){
      addition[level].restart();
    }
    else if(type==MathProblems.OPSub){
      subtraction[level].restart();
    }
  }

  static int nv2=10;
  static int nv3=50;
}