import 'package:flutter/material.dart';
import 'package:mental_maths/src/Widgets/Drawer.dart';
import 'package:mental_maths/src/results.dart';

import '../saving.dart';

class AllResultsPage extends StatefulWidget {
  late Results results;
  Savings savings;
  AllResultsPage({Key? key, required this.savings}) : super(key: key) {
    results = savings.results;
  }

  @override
  _AllResultsPageState createState() => _AllResultsPageState();
}

class _AllResultsPageState extends State<AllResultsPage> {
  @override
  late Results results;
  Widget build(BuildContext context) {
    results = widget.results;
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
              Card(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, child: getTable(1))),
              ),
              Card(
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal, child: getTable(2))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTable(int type) {
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
            'Last ' + Results.nv2.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Last ' + Results.nv3.toString(),
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
      rows: getDataRows(type),
    );
  }

  List<DataRow> getDataRows(int type) {
    var listType = results.addition;
    if (type == 2) listType = results.subtraction;

    List<DataRow> dts = [];

    for (OpRegister o in listType) {
      if (o.nTotal != 0) {
        dts.add(getDataRow(o, type));
      }
    }

    return dts;
  }

  DataRow getDataRow(OpRegister o, int type) {
    Widget v2 = Icon(
      Icons.horizontal_rule,
      color: Colors.black54,
    );
    Widget v3 = Icon(
      Icons.horizontal_rule,
      color: Colors.black54,
    );

    if (o.isV2) {
      v2 = Text(o.promV2.toString() + 's');
    }
    if (o.isV3) {
      v3 = Text(o.promV3.toString() + 's');
    }

    Container pTotal = Container(
        child: Row(
      children: [
        Text(o.promTotal.toString() + 's  '),
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
              results.deleteLevel(type, o.level);
              saveResults();
            });
          },
        )
      ],
    );
  }

  saveResults() {
    widget.savings.writeResults(widget.savings.results);
  }
}
