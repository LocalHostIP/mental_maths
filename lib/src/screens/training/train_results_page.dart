import 'package:flutter/material.dart';
import 'package:mental_maths/src/math_op/operation_register.dart';
import 'package:mental_maths/src/math_op/save.dart';
import 'package:mental_maths/src/widgets/drawer.dart';

//ignore: must_be_immutable
class TrainResultsPage extends StatelessWidget {

  TrainResultsPage({Key? key, required this.results}) : super(key: key);

  Save results;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: getDrawer(context),
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Last ' + Save.nLast1.toString()),
                Tab(text: 'Last ' + Save.nLast2.toString()),
                Tab(
                  text: 'All',
                )
              ],
            ),
            title: Text('Results'),
          ),
          body: TabBarView(
            children: [
              Card(
                child: Column(
                  children: getTiles(2),
                ),
              ),
              Card(
                child: Column(
                  children: getTiles(3),
                ),
              ),
              Card(
                child: Column(
                  children: getTiles(1),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showStartTrainingPage(context);
            },
            child: Icon(Icons.replay_circle_filled),
          ),
        ),
      ),
    );
  }

  List<Widget> getTiles(int type) {
    List<Widget> r = [];
    OperationRegister op;
    for (int i in results.updated[0]) {
      op = results.resultsSum[i];
      r.add(getTile('Addition', op, type));
    }

    for (int i in results.updated[1]) {
      op = results.resultsSub[i];
      r.add(getTile('Subtraction', op, type));
    }

    return r;
  }

  Widget getTile(String operationName, OperationRegister op, int type) {
    ///
    ///Returns the Promedio ListTile corresponding to the operation.dart, it needs a type of media
    ///type: 1=Total, 2=PromV2, 3=PromV3
    ///
    String sign = '+';
    Color c = Colors.red;
    IconData arrow = Icons.arrow_upward;
    String change;

    double df = op.getDifference();
    double pm = op.aveTotal;
    String lvlText =
        'lvl ' + op.level.toString() + ' (' + op.nTotal.toString() + ')';
    String recordText = '';
    double record = -1;
    TextStyle recordStyle = TextStyle(fontSize: 12);
    int n = op.nTotal - 10;
    bool validRecord=false;

    switch (type) {
      case 2:
        df = op.getDifferenceV2();
        pm = op.aveV2;
        lvlText = 'lvl ' + op.level.toString();
        record = op.recordL1;
        n = Save.nLast1;
        validRecord=op.isValidRecordL1;
        break;
      case 3:
        df = op.getDifferenceV3();
        pm = op.aveV3;
        lvlText = 'lvl ' + op.level.toString();
        record = op.recordL2;
        n = Save.nLast2;
        validRecord=op.isValidRecordL2;
        break;
    }
    if (record == -1 || !validRecord)
      recordText = '   ';
    else
      recordText = 'Record: $record';

    if (df < 0) {
      sign = '';
      c = Colors.green;
      arrow = Icons.arrow_downward;
      if (pm == record && n < op.nTotal) {
        recordText = 'New record: $record';
        recordStyle = TextStyle(fontSize: 12, color: Colors.green);
        arrow = Icons.tag_faces;
      }
    }

    change = sign + df.toString();
    if (df == pm) {
      change = '';
      c = Colors.black54;
      arrow = Icons.gps_fixed_rounded;

      if (op.isNew) {
        arrow = Icons.fiber_new;
        if (type == 1) op.isNew = false;
      }
    }

    return ListTile(
      title: Text(operationName),
      leading: Icon(
        arrow,
        color: c,
      ),
      subtitle: Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(lvlText),
        SizedBox(
          width: 10,
        ),
        Text(recordText, style: recordStyle)
      ])),
      enabled: true,
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            Text(change, style: TextStyle(color: c, fontSize: 13)),
            SizedBox(
              width: 15,
            ),
            Text(pm.toString() + 's',
                style: TextStyle(color: c, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  void _showStartTrainingPage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/startTrain', (r) => false);
  }
}
