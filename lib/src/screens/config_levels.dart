import 'package:flutter/material.dart';
import 'package:mental_maths/src/config.dart';
import 'package:mental_maths/src/math_op/math_problems.dart';

//ignore: must_be_immutable
class ConfigLevelsPage extends StatefulWidget {
  ConfigLevelsPage({Key? key, required this.tSettings}) : super(key: key);
  TrainingSettings tSettings;

  @override
  _ConfigLevelsPageState createState() => _ConfigLevelsPageState();
}

class _ConfigLevelsPageState extends State<ConfigLevelsPage> {
  String _operationTitle = '';
  String _op = '';
  bool _lvl1 = false;
  bool _lvl2 = false;
  bool _lvl3 = false;
  bool _lvl4 = false;
  bool _lvl5 = false;
  bool _lvl6 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_operationTitle + ' levels'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Card(
            elevation: 4,
            margin: const EdgeInsets.fromLTRB(32.0, 8, 32, 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              children: [
                CheckboxListTile(
                  value: _lvl1,
                  onChanged: (ch) {
                    setState(() {
                      _lvl1 = ch!;
                      if (!canUncheck()) _lvl1 = true;
                    });
                  },
                  title: Text('Level 1'),
                  secondary:
                      Text('9' + widget.tSettings.currentOPSettings + '9'),
                ),
                CheckboxListTile(
                  value: _lvl2,
                  onChanged: (ch) {
                    setState(() {
                      _lvl2 = ch!;
                      if (!canUncheck()) _lvl2 = true;
                    });
                  },
                  title: Text('Level 2'),
                  secondary:
                      Text('99' + widget.tSettings.currentOPSettings + '9'),
                ),
                CheckboxListTile(
                  value: _lvl3,
                  onChanged: (ch) {
                    setState(() {
                      _lvl3 = ch!;
                      if (!canUncheck()) _lvl3 = true;
                    });
                  },
                  title: Text('Level 3'),
                  secondary:
                      Text('99' + widget.tSettings.currentOPSettings + '99'),
                ),
                CheckboxListTile(
                  value: _lvl4,
                  onChanged: (ch) {
                    setState(() {
                      _lvl4 = ch!;
                      if (!canUncheck()) _lvl4 = true;
                    });
                  },
                  title: Text('Level 4'),
                  secondary:
                      Text('999' + widget.tSettings.currentOPSettings + '99'),
                ),
                CheckboxListTile(
                  value: _lvl5,
                  onChanged: (ch) {
                    setState(() {
                      _lvl5 = ch!;
                      if (!canUncheck()) _lvl5 = true;
                    });
                  },
                  title: Text('Level 5'),
                  secondary:
                      Text('999' + widget.tSettings.currentOPSettings + '999'),
                ),
                CheckboxListTile(
                  value: _lvl6,
                  onChanged: (ch) {
                    setState(() {
                      _lvl6 = ch!;
                      if (!canUncheck()) _lvl6 = true;
                    });
                  },
                  title: Text('Level 6'),
                  secondary:
                      Text('9999' + widget.tSettings.currentOPSettings + '999'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
              width: 120,
              height: 40, // <-- Your width
              child: ElevatedButton(
                onPressed: () {
                  _showStartTrainPage(context);
                },
                child: Text("Accept"),
              )),
        ],
      ),
    );
  }

  void _showStartTrainPage(BuildContext context) {
    ///Returns to start train page but with levels changed
    List<int> levels = [];
    if (_lvl1) levels.add(1);
    if (_lvl2) levels.add(2);
    if (_lvl3) levels.add(3);
    if (_lvl4) levels.add(4);
    if (_lvl5) levels.add(5);
    if (_lvl6) levels.add(6);
    widget.tSettings.setLevels(_op, levels);
    //Navigator.of(context).pushNamed("/startTrain");
    Navigator.pushNamedAndRemoveUntil(context, "/startTrain", (r) => false);
  }

  bool canUncheck() {
    ///Can't unchecked if there is no other checked
    return (_lvl1 || _lvl2 || _lvl3 || _lvl4 || _lvl5 || _lvl6);
  }

  @override
  void initState() {
    // TODO: implement initState
    _op = widget.tSettings.currentOPSettings;
    if (_op == MathProblems.OPSum)
      _operationTitle = 'Addition';
    else if (_op == MathProblems.OPSub) _operationTitle = 'Subtraction';

    for (int i in widget.tSettings.getLevels(_op)) {
      switch (i) {
        case 1:
          _lvl1 = true;
          break;
        case 2:
          _lvl2 = true;
          break;
        case 3:
          _lvl3 = true;
          break;
        case 4:
          _lvl4 = true;
          break;
        case 5:
          _lvl5 = true;
          break;
        case 6:
          _lvl6 = true;
          break;
      }
    }
    super.initState();
  }
}
