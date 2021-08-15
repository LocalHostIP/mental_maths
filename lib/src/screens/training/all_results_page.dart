import 'package:flutter/material.dart';
import 'package:mental_maths/src/math_op/math_problems.dart';
import 'package:mental_maths/src/math_op/operation_register.dart';
import 'package:mental_maths/src/math_op/save.dart';
import 'package:mental_maths/src/widgets/drawer.dart';
import 'package:mental_maths/src/widgets/results_chart.dart';

import '../../file_control.dart';

//ignore: must_be_immutable
class AllResultsPage extends StatefulWidget {
  
  late Save _save;
  FileControl savings;

  AllResultsPage({Key? key, required this.savings}) : super(key: key) {
    _save = savings.save;
  }

  @override
  _AllResultsPageState createState() => _AllResultsPageState();
}

class _AllResultsPageState extends State<AllResultsPage> {
  late Save results;
  late ResultsChart resultChart;

  @override
  Widget build(BuildContext context) {
    results = widget._save;
    resultChart = new ResultsChart(results);
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: getDrawer(context),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.add),
                  text: 'Addition',
                ),
                Tab(icon: Icon(Icons.horizontal_rule), text: 'Subtraction '),
              ],
            ),
            title: Text('Results'),
          ),
          body: TabBarView(
            children: [
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: _getGraphsCards(MathProblems.OPSum)),
                ),
              ),
              //),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: _getGraphsCards(MathProblems.OPSub)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(String type, int level) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete level $level'),
          content: SingleChildScrollView(child: Text('Are you sure?')),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                setState(() {
                  results.deleteLevel(type, level);
                  _saveResults();
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRestartDialog(String type, int level) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete level $level'),
          content: SingleChildScrollView(child: Text('Are you sure? (Archived data will be maintained)')),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                setState(() {
                  results.deleteLevel(type, level);
                  _saveResults();
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _getGraphsCards(String type) {
    List<Widget> list = [];
    List<OperationRegister> listResult = results.resultsSum;
    if (type == MathProblems.OPSub) listResult = results.resultsSub;
    String recordStringL1 = '       ';
    String recordStringL2 = '       ';
    Widget wArchive = Icon(Icons.save,color:Colors.blue); //Archived widget
    Widget wRestart = Icon(Icons.delete,color:Colors.redAccent);

    for (OperationRegister o in listResult) {
      if (o.nTotal != 0) {

        recordStringL1 = '         ';
        recordStringL2 = '         ';
        if (o.isValidRecordL1)
          recordStringL1 = 'R: ' + o.recordL1.toString();
        if (o.isValidRecordL2)
          recordStringL2 = 'R: ' + o.recordL2.toString();

        //Change icon for saving depending
        if(results.isValidSaveToArchive(type,o.level)){
          wArchive = GestureDetector(
            child: Icon(
              Icons.save,
              color: Colors.blueAccent,
            ),
            onTap: () {
              setState(() {
                results.saveToArchive(type, o.level);
                widget.savings.saveResults();
              });
            },
          );
        }else{
          wArchive = GestureDetector(
            child: Icon(
              Icons.save,
              color: Colors.grey,
            )
          );
        }

        //Restart icon
        wRestart=GestureDetector(
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onTap: () {
            _showDeleteDialog(type, o.level);
          },
          );

        if(o.isArchived){
          wArchive=Text('Saved',style: TextStyle(color: Colors.grey,fontSize: 11));
          wRestart = Icon(Icons.new_label,color:Colors.blueGrey);

          wRestart=GestureDetector(
            child: Icon(
              Icons.replay_circle_filled,
              color: Colors.red,
            ),
            onTap: () {
              _showRestartDialog(type, o.level);
            },
          );

        }


        list.add(Container(
            height: 230,
            width: 500,
            padding: EdgeInsets.all(10),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          wRestart,
                          Text(
                            'Level ' + o.level.toString(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          ),
                          Text(
                            'Total: ' + o.nTotal.toString(),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                          wArchive
                        ],
                      ),
                    ),
                    SizedBox(height: 1),
                    resultChart.getBarChart(type, o.level),
                    SizedBox(height: 4),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            recordStringL1,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                          Text(
                            recordStringL2,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                          SizedBox(width: 40,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
      }
    }
    return list;
  }

  void _saveResults() {
    widget.savings.saveResults();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}
