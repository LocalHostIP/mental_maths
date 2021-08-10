import 'package:flutter/material.dart';
import 'package:mental_maths/src/widgets/drawer.dart';
import 'package:settings_ui/settings_ui.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  bool _value=false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: getDrawer(context),
      body:
      SettingsList(
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
        ],
      ),
    );
  }
}
