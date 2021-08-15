import 'package:flutter/material.dart';
import 'package:mental_maths/src/file_control.dart';
import 'package:mental_maths/src/ranking/ranking_save.dart';

//ignore: must_be_immutable
class SetNameWidget extends StatefulWidget {
  /// initial selection for the slider
  RankingSave rankingSave;
  FileControl fileControl;
  bool canCancel=false;
  SetNameWidget({Key? key, required this.rankingSave,required this.canCancel,required this.fileControl});

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
          widget.canCancel? Text('This will restart your not archived data',style: TextStyle(fontSize: 12,color: Colors.redAccent)):Text('')
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
          if(widget.canCancel){
            //If setting name later restart all averages
            widget.rankingSave.setName(_controller.text,widget.fileControl.save);

          }else{
            //If setting name for first time
            widget.rankingSave.setFirstName(_controller.text);
          }

          widget.fileControl.saveRank();
        }
        Navigator.of(context).pop();
      },

    );
  }
}
