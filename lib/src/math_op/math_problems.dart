import 'dart:math';

import 'operation.dart';

class MathProblems{
  /// Class for generating and controlling math problems ///
  Random random = new Random();
  final List<String> operators; //Possible operators
  final int limit; //Amount of operations
  late List<int> lvlSum; //Level of operations
  late List<int> lvlSub;
  int currentIndex=-1; //Current index problem
  Stopwatch _stopwatch = Stopwatch();

  List<Operation> operations=[]; //Al problems (operations)

  MathProblems(this.limit,this.operators,List<List<int>> lvls){
    for (int i=0;i<operators.length;i++){
      if(operators[i]==MathProblems.OPSum)
        lvlSum=lvls[i];
      else if(operators[i]==MathProblems.OPSub)
        lvlSub=lvls[i];
    }
    generateProblems();
  }

  void generateProblems(){
    finished=false;
    /// Creates all problems according to levels///
    String op;
    int level;
    var nLength;
    int inf1;
    int inf2;
    num n1;
    num n2;
    for(var i = 0;i<this.limit;i++){
      op=this.operators[random.nextInt(this.operators.length)]; //get a random operator

      //Get level according to operator
      level=2;
      if(op==MathProblems.OPSum)
        level=lvlSum[random.nextInt(lvlSum.length)]; //get a random level
      else if (op==MathProblems.OPSub)
        level=lvlSub[random.nextInt(lvlSub.length)]; //get a random level

      nLength= this.getLengthNumbers(level); // get Lenght of numbers
      inf1 = pow(10,nLength[0]-1).floor();
      inf2 = pow(10,nLength[1]-1).floor();
      n1=inf1+random.nextInt(inf1*10-inf1); // Get random numbers
      n2=inf2+random.nextInt(inf2*10-inf2);

      //If rest is negative change numbers order
      if (op==MathProblems.OPSub && n1-n2<0){
        var aux=n2;
        n2=n1;
        n1=aux;
      }

      Operation operation= Operation(operator: op, n1: n1, n2: n2, level: level);
      operations.add(operation);
    }
  }

  num getNumber1(){
    return operations[currentIndex].n1;
  }
  num getNumber2(){
    return operations[currentIndex].n2;
  }
  String getOperation(){
    return operations[currentIndex].operator;
  }
  int getTime(){
    return operations[currentIndex].time;
  }
  int getLevel(){
    return operations[currentIndex].level;
  }

  bool finished=false;

  void startClock(){
    /// Starts the timer for the current problem///
    _stopwatch.reset();
    _stopwatch.start();
  }

  void stopClock(){
    /// Starts the timer for the current problem///
    _stopwatch.stop();
    operations[currentIndex].time=_stopwatch.elapsed.inMilliseconds;
  }

  void nextProblem(){
    /// Changes to next problem the current index, even when is the first problem is necessary to call this method///
    if (currentIndex!=-1){
      stopClock();
      operations[currentIndex].setTime(_stopwatch.elapsed.inMilliseconds);
      //print(operations[currentIndex].time/1000);
    }

    if (this.currentIndex<this.limit-1){
      this.currentIndex++;
      startClock();
    }else{
      finished=true;
    }
  }

  void increaseTimePenalization(int t){
    operations[currentIndex].timePenalization+=t;
  }

  double getLastTime(){
    return operations[currentIndex-1].time/1000;
  }

  bool checkAnswer(num res){
    return operations[currentIndex].sol==res;
  }

  List<int> getLengthNumbers(int level){
    var out=[-1,-1];
    int half = ((level+1)/2).ceil();
    int mod = (level+1)%2;
    if (mod==0){
      out=[half,half];
    }
    else{
      out=[half,half-1];
      //Shuffle order
      if (random.nextBool()){
        int aux = out[0];
        out[0]=out[1];
        out[1]=aux;
      }
    }
    return out;
  }

  static const String OPSum = '+';
  static const String OPSub = '-';
}
