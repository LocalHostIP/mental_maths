import 'package:flutter/material.dart';
import 'package:mental_maths/src/widgets/drawer.dart';

class ArchivedPage extends StatefulWidget {
  const ArchivedPage({Key? key}) : super(key: key);
  @override
  _ArchivedPageState createState() => _ArchivedPageState();
}

class _ArchivedPageState extends State<ArchivedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Archived'),
        ),
        drawer: getDrawer(context),
    );
  }
}
