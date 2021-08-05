import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mental_maths/src/Widgets/Drawer.dart';
import 'package:mental_maths/src/config.dart';
import 'package:mental_maths/src/problems_generator.dart';

class StartTrainPage extends StatefulWidget {
  StartTrainPage({Key? key, required this.tsettigns}) : super(key: key);
  TrainingSettings tsettigns = new TrainingSettings();
  @override
  _StartTrainPageState createState() => _StartTrainPageState();
}

class _StartTrainPageState extends State<StartTrainPage>  {
  String lvlSum='3';
  String lvlSub='2';
  double limit=10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Train'),
      ),
      drawer: getDrawer(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: (){_showTrainer(context);},
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Card(
            elevation: 4,
            margin: const EdgeInsets.fromLTRB(32.0, 8, 32, 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: [
                ListTile(
                  leading: Checkbox(value: widget.tsettigns.addition,
                    onChanged: (ch){
                      setState(() {
                        widget.tsettigns.addition=ch!;
                        if(widget.tsettigns.getActiveOperators().length==0){
                          widget.tsettigns.addition=true;
                        }
                      });
                    },
                  ),
                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Addition'),
                        Text('lvl ('+lvlSum+')',style: const TextStyle(color: Colors.black54,fontSize: 15),)
                      ]),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    _showConfigLevelsPage(context,MathProblem.OPSum);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Checkbox(value: widget.tsettigns.subtraction,
                    onChanged: (ch){
                      setState(() {
                        widget.tsettigns.subtraction=ch!;
                        if(widget.tsettigns.getActiveOperators().length==0){
                          widget.tsettigns.subtraction=true;
                        }
                      });
                    }),
                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtraction'),
                        Text('lvl ('+lvlSub+')',style: const TextStyle(color: Colors.black54,fontSize: 15),)
                      ]),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    _showConfigLevelsPage(context,MathProblem.OPRest);
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Center(
            child: Text('Number of operations: '+limit.round().toString(),
            style: TextStyle(fontSize: 16),),
          ),
          SizedBox(height: 20,),
          Slider(
            value: limit, onChanged: (ch){
              setState(() {
                limit=ch;
              });
              widget.tsettigns.limitOP=limit.round();
          },
            max: 30,
            min: 2,
            label: limit.round().toString(),
            divisions: 25,
          ),
        ],
      )
    );
  }

  void _showConfigLevelsPage(BuildContext context,String op) {
    widget.tsettigns.currentOPSettings=op;
    Navigator.of(context).pushNamed("/configLevels");
  }

  void _showTrainer(BuildContext context){
    Navigator.of(context).pushNamed('/trainer');
  }

  @override
  void initState() {
    // TODO: implement initState
    //Create lvl label on addition
    lvlSum='';
    for (int i in widget.tsettigns.getLevels(MathProblem.OPSum)){
      lvlSum=lvlSum+i.toString()+',';
    }
    lvlSum= lvlSum.substring(0,lvlSum.length-1);

    //Create lvl label on subtraction
    lvlSub='';
    for (int i in widget.tsettigns.getLevels(MathProblem.OPRest)){
      lvlSub=lvlSub+i.toString()+',';
    }
    lvlSub=lvlSub.substring(0,lvlSub.length-1);
    super.initState();
  }

}
