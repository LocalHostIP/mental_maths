import 'package:flutter/material.dart';
import 'package:mental_maths/src/math_op/archived.dart';
import 'package:mental_maths/src/math_op/math_problems.dart';
import 'package:mental_maths/src/math_op/save.dart';
import 'package:mental_maths/src/widgets/drawer.dart';

import '../config.dart';

//ignore: must_be_immutable
class SelectArchivedPage extends StatefulWidget {
  SelectArchivedPage({Key? key, required this.save,required this.currentSelected}) : super(key: key);
  Save save;
  CurrentSelected currentSelected;
  @override
  _SelectArchivedPageState createState() => _SelectArchivedPageState();
}

class _SelectArchivedPageState extends State<SelectArchivedPage> {
  @override
  late Save save;
  Widget build(BuildContext context) {
    save = widget.save;

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
            title: Text('Archived results'),
          ),
          body: TabBarView(
            children: [
              Center(
                child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _getList(MathProblems.OPSum),
                ),)
              ),
              //),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _getList(MathProblems.OPSub),
                ),)
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getList(String type) {
    var listType = save.archivedSum;
    List<Widget> list = [];
    if (type == MathProblems.OPSub) listType = save.archivedSub;

    for (Archived a in listType) {
      if (a.lastIndex >= 0) {
        list.add(Card(
          elevation: 5,
          child: new ListTile(
            leading: Icon(Icons.inventory,color: Colors.lightBlueAccent,),
            title: Text('Level ' + a.level.toString(),
            style: TextStyle(color: Colors.black87),),
            subtitle: Text((a.lastIndex+1).toString()+'/'+Archived.nMax.toString()+' archived'),
            onTap: (){
              setState(() {
                widget.currentSelected.currentArchived=a;
                Navigator.of(context).pushNamed("/selectedArchived");
              });
            },
          ),
        ));
      }
    }

    if (list.isEmpty) {
      list.add(ListTile(
        leading: Icon(
          Icons.search_off,
          color: Colors.black54,
          size: 40,
        ),
        title: Text(
          'No saves found',
          style: TextStyle(color: Colors.black54, fontSize: 20),
        ),
      ));
    }

    return list;
  }
}
