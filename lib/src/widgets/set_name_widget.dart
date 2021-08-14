import 'package:flutter/material.dart';
import 'package:mental_maths/src/ranking/ranking_save.dart';

//ignore: must_be_immutable
class SetNameWidget extends StatefulWidget {
  /// initial selection for the slider
  RankingSave rankingSave;
  bool canCancel=false;
  SetNameWidget({Key? key, required this.rankingSave,required this.canCancel});

  @override
  _SetNameWidgetState createState() => _SetNameWidgetState();
}

class _SetNameWidgetState extends State<SetNameWidget> {
  /// current selection of the slider
  bool confirmDisabled=false;
  TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    _controller.addListener(() {

      if (_controller.text.isEmpty){
        setState(() {
          confirmDisabled=true;
        });
      }else{
        setState(() {
          confirmDisabled=false;
        });
      }

    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set a name'),
      content:SingleChildScrollView(child: Column(
        children: [
          TextField(textAlign: TextAlign.center,maxLength: 15,autofocus: true,controller:_controller,),
          SizedBox(height: 15),
          Text('Your new records will appear with this name on global rankings',style: TextStyle(fontSize: 12,color: Colors.black54),),
        ],
      )),
      actions: <Widget>[
        widget.canCancel?TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ):Text(''),
        _buildConfirmButton(context),
      ],
    );
  }

  _buildConfirmButton(BuildContext context){
    return TextButton(
      child: Text('Confirm',style: TextStyle(),),
      onPressed: confirmDisabled? null: () {
        if(_controller.text.isNotEmpty){
          widget.rankingSave.setName(_controller.text);
        }
        Navigator.of(context).pop();
      },

    );
  }
}
