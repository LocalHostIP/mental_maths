import 'package:flutter/material.dart';
import 'package:mental_maths/src/ranking/ranking_firebase.dart';
import 'package:mental_maths/src/ranking/ranking_save.dart';
import 'package:mental_maths/src/widgets/drawer.dart';
import 'package:mental_maths/src/widgets/set_name_widget.dart';

//ignore: must_be_immutable
class RankingPage extends StatefulWidget {
  RankingPage({Key? key,required this.rankingSave}) : super(key: key);
  RankingSave rankingSave;
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> with SingleTickerProviderStateMixin{
  late RankingFirebase _rankingFirebase;

  String _selectedLevel = 'Level 1';
  String _selectedLast = 'Last 10';
  late Widget _tableSum;
  late Widget _tableSub;
  String _typeOP='addition';

  final int opLength=2;

  List<String> itemsLevelDropDown = [
    'Level 1',
    'Level 2',
    'Level 3',
    'level 4',
    'Level 5',
    'Level 6',
    'Level 7',
    'Level 8'
  ];

  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
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
            title: Text('Global ranking'),
          ),
          body: TabBarView(
            children: [
              getSelects(_tableSum),
              getSelects(_tableSub)
            ],
            controller: _tabController,
          ),
        ),
      ),
    );
  }

  _showSetNameWidget() async{
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return new SetNameWidget(rankingSave: widget.rankingSave,canCancel: false,);
        }
    ).then((value){
      if(!widget.rankingSave.isNameSet){
        _showSetNameWidget();
      }else{
        refreshTableData();
      }
    });
  }

  Widget getSelects(Widget table){
    return SingleChildScrollView(
        child:SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Card(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Ranking: '+_rankingFirebase.pos.toString(),
                                style: TextStyle(fontSize: 16),
                              ),
                              Divider(
                                color: Colors.black54,
                                height: 10,
                                thickness: 100,
                              ),
                              Text(
                                'Record: '+_rankingFirebase.ave.toString(),
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                height: 8,
                              )
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      elevation: 3,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Card(
                        child:
                        Row(
                          children: [
                            SizedBox(width: 15,),
                            SizedBox(width: 150, child: Column(
                              children: [
                                getDropDownLevel(),
                                getDropDownLast()
                              ],
                            )),
                            SizedBox(width: 10,),
                          ],
                        )
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10,),
            Center(
                child: Container(
                    alignment: Alignment.center,
                    child: table
                )
            )
          ]),
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    //getUsers();
    super.initState();
    _rankingFirebase = RankingFirebase(widget.rankingSave);
    _tableSum=Image(image: AssetImage('assets/loading.gif'));
    _tableSub=Image(image: AssetImage('assets/loading.gif'));

    _tabController = TabController(length: opLength, vsync: this);
    _tabController.addListener(() {
      _typeOP='addition';
      if(_tabController.index==1)
        _typeOP='subtraction';
      refreshTableData();
    });

    if(widget.rankingSave.isNameSet){
      refreshTableData();
    }
    else{
      WidgetsBinding.instance!.addPostFrameCallback((_) =>_showSetNameWidget() );
    }
  }

  refreshTableData() async{
    int level = itemsLevelDropDown.indexOf(_selectedLevel)+1;
    int lastV=1;

    if(_selectedLast=='Last 50')
      lastV=2;

    setState(() {
      if(_typeOP=='addition')
        _tableSum=Image(image: AssetImage('assets/loading.gif'));
      else
        _tableSub=Image(image: AssetImage('assets/loading.gif'));
    });

    var data = await _rankingFirebase.getRankings(_typeOP,level,lastV);

    if (data.length>0){
      setState(() {
        if(_typeOP=='addition')
          _tableSum=getTable(new TableData(data));
        else
          _tableSub=getTable(new TableData(data));
      });
    }else{
      setState(() {
        if(_typeOP=='addition')
          _tableSum=Text('No records found');
        else
          _tableSub=Text('No records found');
      });
    }
  }

  Widget getTable(data) {
    return PaginatedDataTable(
      source: data,
      columns: [
        DataColumn(label: Center(child: Text('Rank',textAlign: TextAlign.center,),)),
        DataColumn(label: Center(child: Text('Name',textAlign: TextAlign.center))),
        DataColumn(label: Center(child: Text('Ave',textAlign: TextAlign.center)))
      ],
      columnSpacing: 75,
      horizontalMargin: 25,
      rowsPerPage: 25,
      showCheckboxColumn: false,

    );
  }

  DropdownButton<String> getDropDownLevel() {
    return DropdownButton<String>(
      value: _selectedLevel,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black54),
      underline: Container(
        height: 2,
        color: Colors.blueAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedLevel = newValue!;
          refreshTableData();
        });
      },
      isExpanded: true,
      items: itemsLevelDropDown.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  DropdownButton<String> getDropDownLast() {
    return DropdownButton<String>(
      value: _selectedLast,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      isExpanded: true,
      style: const TextStyle(color: Colors.black54),
      underline: Container(
        height: 2,
        color: Colors.blueAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedLast = newValue!;
          refreshTableData();
        });
      },
      items: <String>[
        'Last 10',
        'Last 50',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

// The "soruce" of the table
class TableData extends DataTableSource {
  // Generate some made-up data

  TableData(this.data);

  late List<Rank> data;

  bool get isRowCountApproximate => false;
  int get rowCount => data.length;
  int get selectedRowCount => 1;

  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(data[index].position.toString(),textAlign: TextAlign.center,),),
      DataCell(Text(data[index].name,textAlign: TextAlign.center,style: data[index].isMain? TextStyle(color: Colors.green):TextStyle(color: Colors.black87))),
      DataCell(Text(data[index].ave.toString(),textAlign: TextAlign.center)),
    ]);
  }

}
