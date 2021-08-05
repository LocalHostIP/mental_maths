import 'package:mental_maths/src/problems_generator.dart';

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
    //Initiate all levels on every operation
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
      if (op.operator==MathProblem.OPSum){
        addition[op.level].addOperation(op);

        if (!updated[0].contains(op.level))
          updated[0].add(op.level);
      }
      else if(op.operator==MathProblem.OPRest){
        subtraction[op.level].addOperation(op);
        if (!updated[1].contains(op.level))
          updated[1].add(op.level);
      }
    }
  }

  void deleteLevel(int type, int level){
    if (type==1){
      addition[level].restart();
    }
    else if(type==2){
      subtraction[level].restart();
    }
  }

  static int nv2=10;
  static int nv3=50;
}

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
  bool isV2=false;
  bool isV3=false;
  
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
        isNew = json['isNew'],
        isV2 = json['isV2'],
        isV3 = json['isV3'];

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
    'isV2':isV2,
    'isV3':isV3
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
      isV2=true;
    }else{
      promV2=0;
      isV2=false;
    }

    if (history.length>=Results.nv3){
      promV3=getSum(history,Results.nv3)/Results.nv3/10;
      promV3=promV3.round()/100;
      isV3=true;
    }else{
      promV3=0;
      isV3=false;
    }
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
    isV2=false;
    isV3=false;
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