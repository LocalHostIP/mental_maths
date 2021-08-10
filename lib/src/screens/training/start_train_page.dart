import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mental_maths/src/config.dart';
import 'package:mental_maths/src/math_op/math_problems.dart';
import 'package:mental_maths/src/widgets/drawer.dart';

//ignore: must_be_immutable
class StartTrainPage extends StatefulWidget {
  StartTrainPage({Key? key, required this.tSettings}) : super(key: key);
  TrainingSettings tSettings = new TrainingSettings();

  @override
  _StartTrainPageState createState() => _StartTrainPageState();
}

class _StartTrainPageState extends State<StartTrainPage> {
  String _lvlSum = '3';
  String _lvlSub = '2';
  double _limit = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Train'),
        ),
        drawer: getDrawer(context),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () {
            _showTrainer(context);
          },
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Card(
              elevation: 4,
              margin: const EdgeInsets.fromLTRB(32.0, 8, 32, 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                children: [
                  ListTile(
                    leading: Checkbox(
                      value: widget.tSettings.addition,
                      onChanged: (ch) {
                        setState(() {
                          widget.tSettings.addition = ch!;
                          if (widget.tSettings.getActiveOperators().length ==
                              0) {
                            widget.tSettings.addition = true;
                          }
                        });
                      },
                    ),
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Addition'),
                          Text(
                            'lvl (' + _lvlSum + ')',
                            style: const TextStyle(fontSize: 15),
                          )
                        ]),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      _showConfigLevelsPage(context, MathProblems.OPSum);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Checkbox(
                        value: widget.tSettings.subtraction,
                        onChanged: (ch) {
                          setState(() {
                            widget.tSettings.subtraction = ch!;
                            if (widget.tSettings.getActiveOperators().length ==
                                0) {
                              widget.tSettings.subtraction = true;
                            }
                          });
                        }),
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtraction'),
                          Text(
                            'lvl (' + _lvlSub + ')',
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 15),
                          )
                        ]),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      _showConfigLevelsPage(context, MathProblems.OPSub);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Number of operations: ' + _limit.round().toString(),
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Slider(
              activeColor: Theme.of(context).primaryColor,

              value: _limit,
              onChanged: (ch) {
                setState(() {
                  _limit = ch;
                });
                widget.tSettings.limitOP = _limit.round();
              },
              max: 30,
              min: 2,
              label: _limit.round().toString(),
              divisions: 25,
            ),
          ],
        ));
  }

  void _showConfigLevelsPage(BuildContext context, String op) {
    widget.tSettings.currentOPSettings = op;
    Navigator.of(context).pushNamed("/configLevels");
  }

  void _showTrainer(BuildContext context) {
    Navigator.of(context).pushNamed('/trainer');
  }

  @override
  void initState() {
    // TODO: implement initState
    //Create lvl label on addition
    _lvlSum = '';
    for (int i in widget.tSettings.getLevels(MathProblems.OPSum)) {
      _lvlSum = _lvlSum + i.toString() + ',';
    }
    _lvlSum = _lvlSum.substring(0, _lvlSum.length - 1);

    //Create lvl label on subtraction
    _lvlSub = '';
    for (int i in widget.tSettings.getLevels(MathProblems.OPSub)) {
      _lvlSub = _lvlSub + i.toString() + ',';
    }
    _lvlSub = _lvlSub.substring(0, _lvlSub.length - 1);

    _limit=widget.tSettings.limitOP.toDouble();

    super.initState();
  }

}
