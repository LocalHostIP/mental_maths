import 'package:flutter/material.dart';
import 'package:mental_maths/src/Widgets/Drawer.dart';
import 'package:mental_maths/src/results.dart';

class TrainResultsPage extends StatelessWidget {

  TrainResultsPage({Key? key,required this.results}) : super(key: key);

  Results results;
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
                Tab(text: 'All',),
                Tab(text: 'Last '+Results.nv2.toString()),
                Tab(text: 'Last '+Results.nv3.toString()),
              ],
            ),
            title: Text('Results'),

          ),
          body: TabBarView(
            children: [
              Card(
                child: Column(
                  children: getTiles(1),
                ),
              ),
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
            ],
          ),
          floatingActionButton: FloatingActionButton(onPressed: (){
            _showStartTrainingPage(context);
          },child: Icon(Icons.restart_alt),),
        ),
      ),
    );
  }

  List<Widget> getTiles(int type){
    List<Widget> r=[];
    OpRegister op;
    for (int i in results.updated[0]){
      op = results.addition[i];
      r.add(getTile('Addition',op,type));
    }

    for (int i in results.updated[1]){
      op = results.subtraction[i];
      r.add(getTile('Subtraction',op,type));
    }

    return r;
  }

  Widget getTile(String operationName,OpRegister op,int type){
    ///
    ///Returns the Promedio ListTile corresponding to the operation, it needs a type of media
    ///type: 1=Total, 2=PromV2, 3=PromV3
    ///
    String sign='+';
    Color c=Colors.red;
    IconData arrow=Icons.arrow_upward;
    String change;

    double  df = op.getDifference();
    double pm = op.promTotal;
    String subtitle = 'lvl '+ op.level.toString() +' (total: '+op.nTotal.toString()+')';
    bool available=true;

    switch(type){
      case 2:
        df=op.getDifferenceV2();
        pm=op.promV2;
        subtitle = 'lvl '+ op.level.toString();
        available=op.isV2;
        break;
      case 3:
        df=op.getDifferenceV3();
        pm=op.promV3;
        subtitle = 'lvl '+ op.level.toString();
        available=op.isV3;
        break;
    }

    if (df<0){
      sign='';
      c=Colors.green;
      arrow=Icons.arrow_downward;
    }

    change=sign+df.toString()+'s';
    if(df==pm){
      change='';
      c=Colors.black54;
      arrow=Icons.gps_fixed_rounded;

      if(op.isNew){
        op.isNew=false;
        arrow=Icons.fiber_new;
      }

      if(!available){
        arrow=Icons.do_disturb;
      }
    }

    return ListTile(
      title: Text(operationName),
      leading: Icon(arrow,color: c,),
      subtitle: Text(subtitle),
      enabled: true,
      trailing: Text(change+'          '+pm.toString(),style: TextStyle(color: c),),
    );
  }
  void _showStartTrainingPage(BuildContext context){
    Navigator.pushNamedAndRemoveUntil(context,'/startTrain',(r)=>false);
  }
}
