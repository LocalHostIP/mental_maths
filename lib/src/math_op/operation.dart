import 'math_problems.dart';

class Problem {
  ///Math problem (operation)
  String operator = MathProblems.OPSum;
  num n1 = 0;
  num n2 = 0;
  int level = 0;
  num sol = 0;
  int time = -1;
  int timePenalization = 0;

  //ToJson -- For saving on files
  Map<String, dynamic> toJson() => {
        'operator': operator,
        'level': level,
        'time': time,
      };

  Problem(
      {required this.operator,
      required this.n1,
      required this.n2,
      required this.level}) {
    if (this.operator == MathProblems.OPSum)
      this.sol = n1 + n2;
    else if (this.operator == MathProblems.OPSub)
      this.sol = n1 - n2;
    else
      throw (this.operator + ' is not a valid operator');
  }

  static List<Problem> readListFromJson(List<dynamic> opJson) {
    List<Problem> op = [];
    for (Map<String, dynamic> o in opJson) {
      op.add(Problem.fromJson(o));
    }
    return op;
  }

  Problem.fromJson(Map<String, dynamic> json)
      :
        level = json['level'],
        time = json['time'],
        operator = json['operator'];

  Problem.result(
      {required this.operator, required this.time, required this.level});

  void setTime(int t) {
    this.time = timePenalization + t;
  }
}
