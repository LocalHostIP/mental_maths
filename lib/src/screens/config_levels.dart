import 'package:flutter/material.dart';
import 'package:mental_maths/src/config.dart';
import 'package:mental_maths/src/problems_generator.dart';

class ConfigLevelsPage extends StatefulWidget {
  ConfigLevelsPage({Key? key, required this.tsettigns}) : super(key: key);
  TrainingSettings tsettigns;
  @override
  _ConfigLevelsPageState createState() => _ConfigLevelsPageState();
}

class _ConfigLevelsPageState extends State<ConfigLevelsPage> {
  String operationTitle='';
  String op='';
  bool lvl1=false;
  bool lvl2=false;
  bool lvl3=false;
  bool lvl4=false;
  bool lvl5=false;
  bool lvl6=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(operationTitle+' levels'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
        Card(
          elevation: 4,
          margin: const EdgeInsets.fromLTRB(32.0, 8, 32, 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            children: [
              CheckboxListTile(
                  value: lvl1,
                  onChanged: (ch){
                    setState(() {
                      lvl1=ch!;
                      if (!canUncheck())
                        lvl1=true;
                    });
                  },
                  title: Text('Level 1'),
                  secondary: Text('9'+widget.tsettigns.currentOPSettings+'9'),
              ),
              CheckboxListTile(
                value: lvl2,
                onChanged: (ch){
                  setState(() {
                    lvl2=ch!;
                    if (!canUncheck())
                      lvl2=true;
                  });
                },
                title: Text('Level 2'),
                secondary: Text('99'+widget.tsettigns.currentOPSettings+'9'),
              ),
              CheckboxListTile(
                value: lvl3,
                onChanged: (ch){
                  setState(() {
                    lvl3=ch!;
                    if (!canUncheck())
                      lvl3=true;
                  });
                },
                title: Text('Level 3'),
                secondary: Text('99'+widget.tsettigns.currentOPSettings+'99'),
              ),
              CheckboxListTile(
                value: lvl4,
                onChanged: (ch){
                  setState(() {
                    lvl4=ch!;
                    if (!canUncheck())
                      lvl4=true;
                  });
                },
                title: Text('Level 4'),
                secondary: Text('999'+widget.tsettigns.currentOPSettings+'99'),
              ),
              CheckboxListTile(
                value: lvl5,
                onChanged: (ch){
                  setState(() {
                    lvl5=ch!;
                    if (!canUncheck())
                      lvl5=true;
                  });
                },
                title: Text('Level 5'),
                secondary: Text('999'+widget.tsettigns.currentOPSettings+'999'),
              ),
              CheckboxListTile(
                value: lvl6,
                onChanged: (ch){
                  setState(() {
                    lvl6=ch!;
                    if (!canUncheck())
                      lvl6=true;
                  });
                },
                title: Text('Level 6'),
                secondary: Text('9999'+widget.tsettigns.currentOPSettings+'999'),
              ),
            ],
          ),
        ),
        SizedBox(height: 20,),
        SizedBox(
            width: 120,
            height: 40,// <-- Your width
            child: ElevatedButton(
              onPressed: () {
                _showStartTrainPage(context);
              },
              child: Text("Accept"),
        )
        ),

      ],),
    );
  }

  void _showStartTrainPage(BuildContext context) {
    List<int> levels=[];
    if (lvl1)
      levels.add(1);
    if (lvl2)
      levels.add(2);
    if (lvl3)
      levels.add(3);
    if (lvl4)
      levels.add(4);
    if (lvl5)
      levels.add(5);
    if (lvl6)
      levels.add(6);
    widget.tsettigns.setLevels(op,levels);
    //Navigator.of(context).pushNamed("/startTrain");
    Navigator.pushNamedAndRemoveUntil(context, "/startTrain", (r) => false);
  }

  bool canUncheck(){
    return (lvl1 || lvl2 || lvl3 || lvl4 || lvl5 || lvl6);
  }

  @override
  void initState() {
    // TODO: implement initState
    op=widget.tsettigns.currentOPSettings;
    if(op==MathProblem.OPSum)
      operationTitle='Addition';
    else if(op==MathProblem.OPRest)
      operationTitle='Subtraction';

    for (int i in widget.tsettigns.getLevels(op)){
      switch(i){
        case 1:
          lvl1=true;break;
        case 2:
          lvl2=true;break;
        case 3:
          lvl3=true;break;
        case 4:
          lvl4=true;break;
        case 5:
          lvl5=true;break;
        case 6:
          lvl6=true;break;
      }
    }
    super.initState();
  }
}
