import 'package:flutter/material.dart';
import 'package:mental_maths/src/math_op/file_control.dart';
import 'package:mental_maths/src/widgets/drawer.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../config.dart';

class ConfigPage extends StatefulWidget {
  ConfigPage({Key? key,required this.fileControl}) : super(key: key);
  FileControl fileControl;
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  double seconds = 7;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: getDrawer(context),
      body:
      SettingsList(
        contentPadding: EdgeInsets.only(left: 0,top: 20,right: 0,bottom: 0),
        sections: [
          SettingsSection(
            title: 'Interface',
            tiles: [
              SettingsTile(
                  title: 'Keyboard size',
                  leading: Icon(Icons.keyboard),
                  onPressed: (BuildContext context){
                    Navigator.of(context).pushNamed('/config/keyboardSize');
                  },),
            ],
          ),
          SettingsSection(
            title: 'Training',
            tiles: [
              SettingsTile(
                title: 'Set extra view time',
                leading: Icon(Icons.more_time_rounded),
                onPressed: (BuildContext context){
                  _showSetMoreTimeDialog();
                },),
            ],
          ),
        ],
      ),
    );
  }

  _showSetMoreTimeDialog() async{
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return SetExtraTimeDialog(fileControl: widget.fileControl);
        }
    );
  }

}

// move the dialog into it's own stateful widget.
// It's completely independent from your page
// this is good practice
class SetExtraTimeDialog extends StatefulWidget {
  /// initial selection for the slider
  
  FileControl fileControl;
  SetExtraTimeDialog({Key? key, required this.fileControl}) : super(key: key);

  @override
  _SetExtraTimeDialogState createState() => _SetExtraTimeDialogState();
}

class _SetExtraTimeDialogState extends State<SetExtraTimeDialog> {
  /// current selection of the slider
  late double _time=0;

  @override
  void initState() {
    super.initState();
    this._time=widget.fileControl.settings.extraTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set view time'),
      content:SingleChildScrollView(child: Column(
        children: [
          Slider(
            activeColor: Theme.of(context).primaryColor,
            value: _time,
            onChanged: (ch) {
              setState(() {
                _time = ch;
              });
            },
            max: 10,
            min: 0,
            label: ((_time).round()).toString(),
            divisions: 20,
          ),
          Text(_time.toString()+ ' seconds'),
          SizedBox(height: 10,),
          Text('This time will also add extra time on your averages',style: TextStyle(fontSize: 13,color: Colors.black54),),
          SizedBox(height: 10,),
          Text('Are you sure?')
        ],
      )),
      actions: <Widget>[
        TextButton(
          child: Text('Confirm'),
          onPressed: () {
            widget.fileControl.settings.extraTime=_time;
            widget.fileControl.saveConfig();
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
  }
}

