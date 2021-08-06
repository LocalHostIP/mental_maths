import 'package:mental_maths/src/math_op/results.dart';

import 'operation.dart';

class OpRegister{
  String name = '';
  int level;
  int nTotal = 0;
  double sum = 0;
  double promTotal = 0;
  double lastPromTotal = 0;
  List<Operation> history = [];
  double promV2=0;
  double lastPromV2=0;
  double promV3=0;
  double lastPromV3=0;

  bool isNew=true;

  OpRegister({required this.name,required this.level});

  OpRegister.fromJson(Map<String,dynamic> json):
        name = json['name'],
        level = json['level'],
        nTotal = json['nTotal'],
        sum = json['sum'],
        promTotal = json['promTotal'],
        lastPromTotal = json['lastPromTotal'],
        history = Operation.readListFromJson(json['history']),
        promV2 = json['promV2'],
        lastPromV2 = json['lastPromV2'],
        promV3 = json['promV3'],
        lastPromV3 = json['lastPromV3'],
        isNew = json['isNew'];

  static List<OpRegister> readListFromJson(List<dynamic> opJson){
    List<OpRegister> op = [];
    for (Map<String,dynamic> o in opJson){
      op.add(OpRegister.fromJson(o));
    }
    return op;
  }

  //ToJson -- For saving on files
  Map<String,dynamic> toJson()=>{
    'name':name,
    'level':level,
    'nTotal':nTotal,
    'sum':sum,
    'promTotal':promTotal,
    'lastPromTotal':lastPromTotal,
    'history':history,
    'promV2':promV2,
    'lastPromV2':lastPromV2,
    'promV3':promV3,
    'lastPromV3':lastPromV3,
    'isNew':isNew,
  };

  void updateLastProm(){
    lastPromTotal=promTotal;
    lastPromV2=promV2;
    lastPromV3=promV3;
  }

  void updateProm(){
    promTotal=sum/nTotal/10;
    promTotal=promTotal.round()/100;

    if (history.length>=Results.nv2){
      promV2=getSum(history,Results.nv2)/Results.nv2/10;
      promV2=promV2.round()/100;
    }else
      promV2=promTotal;

    if (history.length>=Results.nv3){
      promV3=getSum(history,Results.nv3)/Results.nv3/10;
      promV3=promV3.round()/100;
    }else
      promV3=promTotal;
  }

  void addOperation(Operation op){
    nTotal+=1;
    sum+=op.time;
    history.add(op);
    if(history.length>Results.nv3){
      history.removeAt(0);
    }
    updateProm();
  }

  void restart(){
    nTotal = 0;
    sum = 0;
    promTotal = 0;
    lastPromTotal = 0;
    history = [];
    promV2=0;
    lastPromV2=0;
    promV3=0;
    lastPromV3=0;

    isNew=true;
  }

  double getSum(List<Operation> operations,int n){
    //get the sum of times of n items of operations, backwards
    double sum = 0;
    for (int i=operations.length-1;i>=operations.length-n;i--){
      sum+=operations[i].time;
    }
    return sum;
  }

  double getDifference(){
    return num.parse((promTotal-lastPromTotal).toStringAsFixed(2)).toDouble();
  }

  double getDifferenceV2(){
    return num.parse((promV2-lastPromV2).toStringAsFixed(2)).toDouble();
  }

  double getDifferenceV3(){
    return num.parse((promV3-lastPromV3).toStringAsFixed(2)).toDouble();
  }

}