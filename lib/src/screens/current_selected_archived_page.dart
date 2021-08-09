import 'package:flutter/material.dart';
import 'package:mental_maths/src/math_op/archived.dart';
import 'package:mental_maths/src/math_op/math_problems.dart';
import 'package:mental_maths/src/math_op/save.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mental_maths/src/math_op/saving.dart';


//ignore: must_be_immutable
class SelectedArchivePage extends StatefulWidget {
  Archived archived;
  Savings saving;
  SelectedArchivePage({Key? key,required this.archived,required this.saving}) : super(key: key);

  @override
  _SelectedArchivePageState createState() => _SelectedArchivePageState();
}

class _SelectedArchivePageState extends State<SelectedArchivePage> {
  late Archived _archived;
  late Savings _saving;

  late List<charts.Series<ArchivedChartData,int>> _seriesData;
  @override
  Widget build(BuildContext context) {
    _archived=widget.archived;
    _saving=widget.saving;
    _generateData();

    String title = 'Addition - Level: ';
    if(_archived.typeOp==MathProblems.OPSub)
      title='Subtraction - Level';

    title+=_archived.level.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              _getGraphicsCard(),
              Card(
                elevation: 5,
                child:
                Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text('Best records',style: TextStyle(fontSize: 14,color: Colors.black54,fontWeight: FontWeight.w700)),
                      SizedBox(width: 12,),
                      GestureDetector(
                        child: Icon(Icons.replay,color: Colors.red,),
                        onTap: (){_showRestartDialog();},
                      ),
                    ],),
                    ListTile(
                      leading: Icon(Icons.recommend),
                      title: Text('Last '+Save.nLast1.toString()+' : '+_archived.bestL1.toString()),
                    ),
                    ListTile(
                      leading: Icon(Icons.recommend),
                      title: Text('Last '+Save.nLast2.toString()+" : "+_archived.bestL2.toString()),
                    ),
                    ListTile(
                      leading: Icon(Icons.recommend),
                      title: Text('Total : '+_archived.bestAve.toString()),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(children: [
                  SizedBox(height: 10),
                  Text('All saves',style: TextStyle(fontSize: 14,color: Colors.black54,fontWeight: FontWeight.w700)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _getDataTable(),
                  )
                ]),
              )
            ],
          ),
        ),
      )
    );
  }

  DataTable _getDataTable(){
    return DataTable(columns: <DataColumn>[
      DataColumn(
        label: Text(
          'Index',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Last '+Save.nLast1.toString(),
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Last '+Save.nLast2.toString(),
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Total',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Operations',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Delete ',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ],
      rows: _getDataCells(),);
  }

  List<DataRow> _getDataCells(){
    List<DataRow> l = [];
    for (int i=0; i <= _archived.lastIndex;i++){
      l.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text((i).toString())),
            DataCell(Text(_archived.bestsL1[i].toString())),
            DataCell(Text(_archived.bestsL2[i].toString())),
            DataCell(Text(_archived.averages[i].toString())),
            DataCell(Text(_archived.totals[i].toString())),
            DataCell( Icon(Icons.delete,color: Colors.redAccent,) , onTap: ()=>_showDeleteDialog(i)),
          ]
        )
      );
    }
    return l;
  }

  void _generateData(){
    _seriesData=[];

    List <ArchivedChartData> dataL1=[];
    List <ArchivedChartData> dataL2=[];
    List <ArchivedChartData> dataT=[];

    for (int i=0;i<=_archived.lastIndex;i++){
      dataL1.add(new ArchivedChartData(index:i, average:_archived.bestsL1[i], color: charts.MaterialPalette.blue.shadeDefault));
      dataL2.add(new ArchivedChartData(index:i, average:_archived.bestsL2[i], color: charts.MaterialPalette.yellow.shadeDefault));
      dataT.add(new ArchivedChartData(index:i, average:_archived.averages[i], color: charts.MaterialPalette.green.shadeDefault));
    }
    _seriesData.add( new charts.Series(
      id: 'Best of '+Save.nLast1.toString(),
      data: dataL1,
      domainFn: (_seriesData,_) => _seriesData.index,
      measureFn: (_seriesData,_) => _seriesData.average,
      colorFn: (_seriesData,_)=> _seriesData.color,
    ));
    _seriesData.add( new charts.Series(
      id: 'Best of '+Save.nLast2.toString(),
      data: dataL2,
      domainFn: (_seriesData,_) => _seriesData.index,
      measureFn: (_seriesData,_) => _seriesData.average,
      colorFn: (_seriesData,_)=> _seriesData.color,
    ));
    _seriesData.add( new charts.Series(
      id: 'Total',
      data: dataT,
      domainFn: (_seriesData,_) => _seriesData.index,
      measureFn: (_seriesData,_) => _seriesData.average,
      colorFn: (_seriesData,_)=> _seriesData.color,
    ));
  }

  _getChart(){
    return Expanded(child:
    charts.LineChart(
      _seriesData,
      animate: true,
      animationDuration: Duration(seconds: 1),
      defaultRenderer: new charts.LineRendererConfig(
        includePoints: true,
      ),
      behaviors: [
        new charts.SeriesLegend(),
      ],
    )
    );
  }

  Widget _getGraphicsCard(){
    return Container(
      height: 350,
      width: 500,
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
            _getChart()
            ],
          ),
        ),
      )
    );
  }

  Future<void> _showRestartDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Recalculate records'),
          content: SingleChildScrollView(child: Text('Are you sure? You will loose records that might be better that the ones are currently archived')),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                setState(() {
                  _archived.updateRecords();
                  _saving.writeFile();
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

  Future<void> _showDeleteDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete archive on index $index'),
          content: SingleChildScrollView(child: Text('Are you sure?')),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                setState(() {
                  _archived.delete(index);
                  if(_saving.save.getListByType(_archived.typeOp)[_archived.level].isArchived){
                    _saving.save.deleteLevel(_archived.typeOp, _archived.level);
                  }
                  _saving.writeFile();
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
}




class ArchivedChartData{
  final int index;
  final double average;
  final charts.Color color;
  ArchivedChartData({required this.index, required this.average, required this.color});
}
