import 'package:mental_maths/src/math_op/operation_register.dart';
import 'package:mental_maths/src/math_op/save.dart';

class RankingSave{

  late List<double> additionL1;
  late List<double> subtractionL1;

  late List<double> additionL2;
  late List<double> subtractionL2;

  late String name;
  bool isNameSet=false;

  RankingSave(){
    name='Unnamed';
    additionL1=[];
    subtractionL1=[];
    additionL2=[];
    subtractionL2=[];
    isNameSet=false;
    for (int i=0;i<Save.maxLevel;i++){
      additionL1.add(-1);
      subtractionL1.add(-1);
      additionL2.add(-1);
      subtractionL2.add(-1);
    }
  }

  void setName(String name){
    this.name=name;
    isNameSet=true;
    additionL1=[];
    subtractionL1=[];
    additionL2=[];
    subtractionL2=[];
    for (int i=0;i<Save.maxLevel;i++){
      additionL1.add(-1);
      subtractionL1.add(-1);
      additionL2.add(-1);
      subtractionL2.add(-1);
    }
  }

  void update(Save save){
    for (OperationRegister op in save.resultsSum){
      if((op.recordL1<additionL1[op.level] || op.recordL1!=0 ) && op.isValidRecordL1)
        additionL1[op.level]=op.recordL1;
      if((op.recordL2<additionL2[op.level] || op.recordL2!=0) && op.isValidRecordL2)
        additionL2[op.level]=op.recordL2;
    }
    for (OperationRegister op in save.resultsSub){
      if((op.recordL1<subtractionL1[op.level] || op.recordL1!=0 ) && op.isValidRecordL1)
        subtractionL1[op.level]=op.recordL1;
      if((op.recordL2<subtractionL2[op.level] || op.recordL2!=0) && op.isValidRecordL2)
        subtractionL2[op.level]=op.recordL2;
    }
    print(additionL1);
    print(additionL2);
  }
}