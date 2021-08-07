import 'package:mental_maths/src/math_op/save.dart';

import 'operation.dart';

class OperationRegister {
  ///Records operation for a level type of operation 

  String name = '';
  int level = 0;
  int nTotal = 0; //Total number of operations
  double sum = 0; //Total sum
  double aveTotal = 0; //Total average
  double _lastAveTotal = 0;
  List<Problem> history = [];
  double aveV2 = 0; //Average for the las MathProblems.nV2
  double _lastAveV2 = 0;
  double aveV3 = 0; //Average for the las MathProblems.nV3
  double _lastAveV3 = 0;
  bool isNew = true;

  double recordV2 = 0;
  double recordV3 = 0;

  OperationRegister({required this.name, required this.level});

  OperationRegister.fromJson(Map<String, dynamic> json) ///Decode from json
      : name = json['name'],
        level = json['level'],
        nTotal = json['nTotal'],
        sum = json['sum'],
        aveTotal = json['promTotal'],
        _lastAveTotal = json['lastPromTotal'],
        history = Problem.readListFromJson(json['history']),
        aveV2 = json['promV2'],
        _lastAveV2 = json['lastPromV2'],
        aveV3 = json['promV3'],
        _lastAveV3 = json['lastPromV3'],
        isNew = json['isNew'],
        recordV2 = json['recordV2'],
        recordV3 = json['recordV3'];

  static List<OperationRegister> readListFromJson(List<dynamic> opJson) {
    ///Used to create a list of OPRegister items from a json
    List<OperationRegister> op = [];
    for (Map<String, dynamic> o in opJson) {
      op.add(OperationRegister.fromJson(o));
    }
    return op;
  }

  //ToJson -- For saving on files
  Map<String, dynamic> toJson() => { ///Encode to json
        'name': name,
        'level': level,
        'nTotal': nTotal,
        'sum': sum,
        'promTotal': aveTotal,
        'lastPromTotal': _lastAveTotal,
        'history': history,
        'promV2': aveV2,
        'lastPromV2': _lastAveV2,
        'promV3': aveV3,
        'lastPromV3': _lastAveV3,
        'isNew': isNew,
        'recordV2': recordV2,
        'recordV3': recordV3,
      };

  void updateLastProm() {
    ///Update last average
    _lastAveTotal = aveTotal;
    _lastAveV2 = aveV2;
    _lastAveV3 = aveV3;
  }

  void _updateAverage() {
    ///Update prom register
    aveTotal = sum / nTotal / 10;
    aveTotal = aveTotal.round() / 100;

    if (history.length >= Save.nv2) {
      aveV2 = _getSum(history, Save.nv2) / Save.nv2 / 10;
      aveV2 = aveV2.round() / 100;
    } else
      aveV2 = aveTotal;

    if (history.length >= Save.nv3) {
      aveV3 = _getSum(history, Save.nv3) / Save.nv3 / 10;
      aveV3 = aveV3.round() / 100;
    } else
      aveV3 = aveTotal;
  }

  void updateRecords() {
    ///Update register Records
    if (aveV2 < recordV2 || recordV2 == 0 || nTotal <= Save.nv2) {
      recordV2 = aveV2;
    }
    if (aveV3 < recordV3 || recordV3 == 0 || nTotal <= Save.nv3) {
      recordV3 = aveV3;
    }
  }

  void addOperation(Problem op) {
    ///Add new operation and update average
    nTotal += 1;
    sum += op.time;
    history.add(op);
    if (history.length > Save.nv3) {
      history.removeAt(0);
    }
    _updateAverage();
  }

  void restart() {
    nTotal = 0;
    sum = 0;
    aveTotal = 0;
    _lastAveTotal = 0;
    history = [];
    aveV2 = 0;
    _lastAveV2 = 0;
    aveV3 = 0;
    _lastAveV3 = 0;
    recordV3 = 0;
    recordV2 = 0;

    isNew = true;
  }

  double _getSum(List<Problem> operations, int n) {
    ///get the sum of times of n items of operations, backwards (The latest to newest)
    double sum = 0;
    for (int i = operations.length - 1; i >= operations.length - n; i--) {
      sum += operations[i].time;
    }
    return sum;
  }

  double getDifference() {
    return num.parse((aveTotal - _lastAveTotal).toStringAsFixed(2)).toDouble();
  }

  double getDifferenceV2() {
    return num.parse((aveV2 - _lastAveV2).toStringAsFixed(2)).toDouble();
  }

  double getDifferenceV3() {
    return num.parse((aveV3 - _lastAveV3).toStringAsFixed(2)).toDouble();
  }
}
