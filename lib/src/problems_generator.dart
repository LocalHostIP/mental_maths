import 'dart:math';

class MathProblem{
  /// Class for generating and controlling math problems ///
  Random random = new Random();
  final List<String> operators; //Possible operators
  final int limit; //Amount of operations
  late final List<int> lvlSum; //Level of operations
  late final List<int> lvlSub;
  int currentIndex=-1; //Current index problem
  Stopwatch _stopwatch = Stopwatch();

  List<Operation> operations=[]; //Al problems (operations)

  MathProblem(this.limit,this.operators,List<List<int>> lvls){
    for (int i=0;i<operators.length;i++){
      if(operators[i]==MathProblem.OPSum)
        lvlSum=lvls[i];
      else if(operators[i]==MathProblem.OPRest)
        lvlSub=lvls[i];
    }
    generateProblems();
  }

  void generateProblems(){
    finished=false;
    /// Creates all problems acording to levels///
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
      if(op==MathProblem.OPSum)
        level=lvlSum[random.nextInt(lvlSum.length)]; //get a random level
      else if (op==MathProblem.OPRest)
        level=lvlSub[random.nextInt(lvlSub.length)]; //get a random level

      nLength= this.getLengthNumbers(level); // get Lenght of numbers
      inf1 = pow(10,nLength[0]-1).floor();
      inf2 = pow(10,nLength[1]-1).floor();
      n1=inf1+random.nextInt(inf1*10-inf1); // Get random numbers
      n2=inf2+random.nextInt(inf2*10-inf2);

      //If rest is negative change numbers order
      if (op==MathProblem.OPRest && n1-n2<0){
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
    operations[currentIndex].time_penalization+=t;
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
      //Shufle order
      if (random.nextBool()){
        int aux = out[0];
        out[0]=out[1];
        out[1]=aux;
      }
    }
    return out;
  }

  static String OPSum = '+';
  static String OPRest = '-';
}

class Operation{
  String operator=MathProblem.OPSum;
  num n1=0;
  num n2=0;
  int level=0;
  num sol=0;
  int time=-1;
  int time_penalization=0;

  Operation({required this.operator,required this.n1,required this.n2,required this.level}){
    if (this.operator==MathProblem.OPSum)
      this.sol=n1+n2;
    else if(this.operator==MathProblem.OPRest)
      this.sol=n1-n2;
    else
      throw(this.operator+' is not a valid operator');
  }

  Operation.result({required this.operator,required this.time,required this.level});

  void setTime(int t){
    this.time=time_penalization+t;
  }
}