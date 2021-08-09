import 'package:mental_maths/src/math_op/math_problems.dart';

class Archived{
  static final int nMax=100;
  double bestL1=0;
  double bestL2=0;
  double bestAve=0;
  String typeOp=MathProblems.OPSum;
  int level=1;
  List<double>bestsL1=[];
  List<double>bestsL2=[];
  List<double>averages=[];
  List<int> totals=[];
  int lastIndex=-1;
  Archived(this.typeOp,this.level);


  Archived.fromJson(Map<String, dynamic> json) ///Decode from json
      : bestL1 = json['bestL1'],
        bestL2 = json['bestL2'],
        bestAve = json['bestAve'],
        typeOp = json['typeOp'],
        level = json['level'],
        bestsL1 = _readDoubleFromJson(json['bestsL1']),
        bestsL2 = _readDoubleFromJson(json['bestsL2']),
        averages = _readDoubleFromJson(json['averages']),
        lastIndex = json['lastIndex'],
        totals=_readIntFromJson(json['totals']);

  //ToJson -- For saving on files
  Map<String, dynamic> toJson() => { ///Encode to json
    'bestL1': bestL1,
    'bestL2': bestL2,
    'bestAve': bestAve,
    'typeOp': typeOp,
    'level': level,
    'bestsL1': bestsL1,
    'bestsL2': bestsL2,
    'averages': averages,
    'lastIndex': lastIndex,
    'totals':totals
  };

  static List<Archived> readListFromJson(List<dynamic> opJson) {
    ///Used to create a list of Archive items from a json
    List<Archived> op = [];
    for (Map<String, dynamic> o in opJson) {
      op.add(Archived.fromJson(o));
    }
    return op;
  }

  static List<double> _readDoubleFromJson(List<dynamic> opJson) {
    return opJson.cast<double>();
  }
  static List<int> _readIntFromJson(List<dynamic> opJson) {
    return opJson.cast<int>();
  }


  void delete(int index){
    lastIndex-=1;
    bestsL1.removeAt(index);
    bestsL2.removeAt(index);
    averages.removeAt(index);
    totals.removeAt(index);
  }

  void updateRecords(){
    bestL1=0;
    bestL2=0;
    bestAve=0;
    for(double i in bestsL1){
      if (bestL1==0 || bestL1>i)
        bestL1=i;
    }
    for(double i in bestsL2){
      if (bestL2==0 || bestL2>i)
        bestL2=i;
    }
    for(double i in averages){
      if (bestAve==0 || bestAve>i)
        bestAve=i;
    }
  }
}