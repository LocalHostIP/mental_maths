import 'package:mental_maths/src/math_op/operation_register.dart';
import 'package:mental_maths/src/math_op/save.dart';
import 'package:hive/hive.dart';

part 'ranking_save.g.dart';

@HiveType(typeId: 1)
class RankingSave extends HiveObject{
  @HiveField(0)
  late List<double> additionL1;
  @HiveField(1)
  late List<double> subtractionL1;
  @HiveField(2)
  late List<double> additionL2;
  @HiveField(3)
  late List<double> subtractionL2;
  @HiveField(4)
  late String name;
  @HiveField(5)
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

  //ToJson -- For saving on files
  Map<String, dynamic> toJson() => { ///Encode to json
    'name': name,
    'additionL1': additionL1,
    'subtractionL1': subtractionL1,
    'additionL2': additionL2,
    'subtractionL2': subtractionL2,
    'isNameSet': isNameSet,
  };

  ///Decode from json
  static List<double> _readDoubleFromJson(List<dynamic> opJson) {
    return opJson.cast<double>();
  }

  void setFirstName(String name){
    this.name=name;
    isNameSet=true;
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

  void setName(String name,Save save){
    setFirstName(name);
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
    save.restartAverages();
  }
}
