import 'math_problems.dart';

class Operation{
  String operator=MathProblems.OPSum;
  num n1=0;
  num n2=0;
  int level=0;
  num sol=0;
  int time=-1;
  int timePenalization=0;

  //ToJson -- For saving on files
  Map<String,dynamic> toJson()=>{
    'operator':operator,
    'n1':n1,
    'n2':n2,
    'level':level,
    'time':time,
    'sol':sol,
    'time_penalization':timePenalization,
  };

  Operation({required this.operator,required this.n1,required this.n2,required this.level}){
    if (this.operator==MathProblems.OPSum)
      this.sol=n1+n2;
    else if(this.operator==MathProblems.OPSub)
      this.sol=n1-n2;
    else
      throw(this.operator+' is not a valid operator');
  }

  static List<Operation> readListFromJson(List<dynamic> opJson){
    List<Operation> op = [];
    for (Map<String,dynamic> o in opJson){
      op.add(Operation.fromJson(o));
    }
    return op;
  }

  Operation.fromJson(Map<String,dynamic> json):
        n1 = json['n1'],
        level = json['level'],
        n2 = json['n2'],
        sol = json['sol'],
        time = json['time'],
        timePenalization = json['timePenalization'],
        operator = json['operator'];

  Operation.result({required this.operator,required this.time,required this.level});

  void setTime(int t){
    this.time=timePenalization+t;
  }
}