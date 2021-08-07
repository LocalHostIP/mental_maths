import 'package:flutter/material.dart';
import 'package:mental_maths/src/math_op/math_problems.dart';
import 'package:mental_maths/src/math_op/operation_register.dart';
import 'package:mental_maths/src/math_op/save.dart';
import 'package:mental_maths/src/widgets/drawer.dart';
import 'package:mental_maths/src/widgets/results_chart.dart';

import '../math_op/saving.dart';

//ignore: must_be_immutable
class AllResultsPage extends StatefulWidget {
  
  late Save _results;
  Savings savings;

  AllResultsPage({Key? key, required this.savings}) : super(key: key) {
    _results = savings.results;
  }

  @override
  _AllResultsPageState createState() => _AllResultsPageState();
}

class _AllResultsPageState extends State<AllResultsPage> {
  late Save results;
  late ResultsChart resultChart;

  @override
  Widget build(BuildContext context) {
    results = widget._results;
    resultChart = new ResultsChart(results);
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: getDrawer(context),
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

  Widget _getTable(String type) {
    //Will be deleted
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Lvl',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Last ' + Save.nLast1.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Last ' + Save.nLast2.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'All',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Delete',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        )
      ],
      rows: _getDataRows(type),
    );
  }

  List<DataRow> _getDataRows(String type) {
    var listType = results.addition;
    if (type == MathProblems.OPSub) listType = results.subtraction;

    List<DataRow> dts = [];

    for (OperationRegister o in listType) {
      if (o.nTotal != 0) {
        dts.add(_getDataRow(o, type));
      }
    }

    return dts;
  }

  DataRow _getDataRow(OperationRegister o, String type) {
    Widget v2 = Icon(
      Icons.horizontal_rule,
      color: Colors.black54,
    );
    Widget v3 = Icon(
      Icons.horizontal_rule,
      color: Colors.black54,
    );

    v2 = Text(o.aveV2.toString() + 's');

    v3 = Text(o.aveV3.toString() + 's');

    Container pTotal = Container(
        child: Row(
      children: [
        Text(o.aveTotal.toString() + 's  '),
        Text(
          '(' + o.nTotal.toString() + ')',
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    ));

    //Text(o.promV2.toString()+'s')
    return DataRow(
      cells: <DataCell>[
        DataCell(Text('lvl ' + o.level.toString())),
        DataCell(v2),
        DataCell(v3),
        DataCell(pTotal),
        DataCell(
          Icon(
            Icons.delete,
            color: Colors.redAccent,
          ),
          onTap: () {
            setState(() {
              _showDeleteDialog(type, o.level);
            });
          },
        )
      ],
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

  List<Widget> _getGraphsCards(String type) {
    List<Widget> list = [];
    List<OperationRegister> listResult = results.addition;
    if (type == MathProblems.OPSub) listResult = results.subtraction;
    for (OperationRegister o in listResult) {
      if (o.nTotal != 0)
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
                          Text(
                            'Total: ' + o.nTotal.toString(),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                          Text(
                            'Level ' + o.level.toString(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onTap: () {
                              _showDeleteDialog(type, o.level);
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 1),
                    resultChart.getBarChart(type, o.level),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Record: ' + o.recordV2.toString(),
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                          Text(
                            'Record: ' + o.recordV3.toString(),
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                          Text(
                            '              ',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
    }

    return list;
  }

  void _saveResults() {
    widget.savings.save();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}
