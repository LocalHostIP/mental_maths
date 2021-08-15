import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mental_maths/src/math_op/math_problems.dart';
import 'package:mental_maths/src/file_control.dart';
import 'package:mental_maths/src/ranking/ranking_save.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../../config.dart';
import '../../math_op/save.dart';

//ignore: must_be_immutable
class TrainPage extends StatefulWidget {
  Settings settings;
  TrainingSettings trainSettings; //General settings, including Type of problems
  FileControl savings;
  RankingSave rankingSave;
  late Save _results; //Register of results

  TrainPage({Key? key, required this.trainSettings,required this.savings,required this.settings,required this.rankingSave}) : super(key: key){
    _results = savings.save;
  }

  @override
  _TrainPageState createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> with TickerProviderStateMixin{
  TextEditingController _controllerField = new TextEditingController();
  FocusNode _focusNodeField = new FocusNode();
  late final AnimationController _cAnimationOperationText;
  late final Animation<double> _opacityOperationText;
  late final AnimationController _cAnimationTimePenalText;
  late final Animation<double> _opacityTimePenalText;
  String _timeInfo='+2s';
  
  late MathProblems _mathProblem;
  Color _colorInput = Colors.black54;

  TextStyle _timeTextStyle = TextStyle(color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainer'),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context,constrains) {
            var parentHeight = constrains.maxHeight;
            var parentWidth = constrains.maxWidth;
            return _getTrainerWidget(parentWidth,parentHeight);
        })
      ),
    );
  }

  Widget _getTrainerWidget(width,height){
    /// Widget for training ///
    TextStyle _inputStyle = TextStyle(fontSize: height*0.055,color: _colorInput);
    return Column(
    mainAxisAlignment:MainAxisAlignment.spaceBetween,
    children: [
      Column(
        children: [
          SizedBox(height: 15,),
          //Info
          SizedBox(
            width: width*0.75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text((_mathProblem.currentIndex+1).toString()+'/'+_mathProblem.limit.toString(),
                    style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold),textAlign: TextAlign.center)),
                FadeTransition(opacity: _opacityTimePenalText,
                    child: Text(_timeInfo,style: _timeTextStyle))
              ],
            ),),
          //Operation card
          Card(
            child: SizedBox(
              width: width*0.75,
              height: height*0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _getOperationWidget(width,height),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: (){_showOperation();_showTimePenal(1+_mathProblem.getLevel());}, child: Text('View')),
                    ],
                  )
                ],
              ),
            ),
          ),
          //Input card
          Card(
            child: SizedBox(
              width: width*0.75,
              height: height*0.11,

              child: TextField(
                controller: _controllerField,
                style: _inputStyle,
                autofocus: true,
                textAlign: TextAlign.center,
                showCursor: true,
                readOnly: (Platform.isAndroid || Platform.isIOS),
                focusNode: _focusNodeField,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                onTap: (){SystemChannels.textInput.invokeMethod('TextInput.hide');},
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                  EdgeInsets.only(left: 15, bottom: 0, top: 11, right: 15),
                ),
                onSubmitted: (ch)=>_inputChanged(ch,submitted: true),
              ),

            ),
          ),
          //Separation
          SizedBox(width: 10,height: 30),
        ],
      ),
      Column(children: [
        //Keyboard
        Container(
          child: VirtualKeyboard(
            height: height * (widget.settings.keyboardHeight/100),
            width: (widget.settings.keyboardWidth/100) * width,
            textColor: Colors.black54,
            fontSize: 20,
            defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
            type: VirtualKeyboardType.Numeric,
            onKeyPress: (key)=>_keyPressed(key),
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],)
    ],
    );
  }

  Widget _getOperationWidget(width,height){
    /// Widget of current math problem ///
    TextStyle numberStyle = TextStyle(fontSize: height*0.055,color: Colors.black87);
    return Expanded(child:FadeTransition(opacity: _opacityOperationText,
        child:Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_mathProblem.getNumber1().toString(),style: numberStyle),
              Text(_mathProblem.getNumber2().toString(),style: numberStyle),
            ],
          ),
          Text(_mathProblem.getOperation(),style: numberStyle)
        ])),);
  }

  @override
  void initState() {
    // TODO: implement initState
    
    //Create animation for showing numbers
    _cAnimationOperationText = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _cAnimationOperationText.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _cAnimationOperationText.reverse();
      }
    });
    _opacityOperationText = CurvedAnimation(parent: _cAnimationOperationText, curve: Curves.easeOutCubic);

    //Create animation for time penalization
    _cAnimationTimePenalText = new AnimationController(vsync: this, duration: Duration(milliseconds: 1500 ));
    _cAnimationTimePenalText.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _cAnimationTimePenalText.reverse();
      }
    });
    _opacityTimePenalText = CurvedAnimation(parent: _cAnimationTimePenalText, curve: Curves.easeOut);

    //Create MathProblems
    //create levels array
    List<List<int>> lvls = [];
    var ops=widget.trainSettings.getActiveOperators();
    for (String op in ops)
      lvls.add(widget.trainSettings.getLevels(op));
    _mathProblem = MathProblems(widget.trainSettings.limitOP,ops,lvls);

    //Start first problem timer
    _mathProblem.nextProblem();

    _showOperation();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    this._controllerField.dispose();
    _cAnimationOperationText.dispose();
    _focusNodeField.dispose();
    _cAnimationTimePenalText.dispose();

    super.dispose();
  }

  void _keyPressed(key){
    /// When the virtual keyboard is pressed change text of input///
    if (key.keyType==VirtualKeyboardKeyType.String){
      this._controllerField.text=_controllerField.text+key.text;
    }else if(key.action == VirtualKeyboardKeyAction.Backspace){
      this._controllerField.text= _controllerField.text.substring(0,_controllerField.text.length-1);
    }
    _inputChanged(_controllerField.text);
  }

  void _showOperation(){
    /// Starts animation for showing the numbers of the problem ///
    _cAnimationOperationText.duration=Duration(milliseconds:((1000*widget.settings.extraTime)/2).round()+100+_mathProblem.getLevel()*200);
    _cAnimationOperationText.forward(from:0);
    if(widget.settings.extraTime!=0){
      _mathProblem.increaseTimePenalization((widget.settings.extraTime*1000).round());
    }
  }
  
  void _showTimePenal(int seconds){
    setState(() {
      _timeTextStyle = TextStyle(color: Colors.red);
      _timeInfo='+'+seconds.toString()+'s';
    });
    _cAnimationTimePenalText.forward(from: 0);
    _mathProblem.increaseTimePenalization(seconds*1000);
  }

  void _showTimeOperation(){
    setState(() {
      _timeTextStyle = TextStyle(color: Colors.black54);
      _timeInfo=_mathProblem.getLastTime().toString();
    });
    _cAnimationTimePenalText.forward(from: 0);
  }

  void _inputChanged(String ch,{bool submitted=false}){
    /// checks if input has the answer when it changes///
    //When entered is pressed input looses focus, this returns focus to input
    _controllerField.text=ch;
    FocusScope.of(context).requestFocus(_focusNodeField);
    _controllerField.selection = TextSelection.fromPosition(TextPosition(offset: _controllerField.text.length));
    //check if is correct answer1

    if(_mathProblem.checkAnswer(num.parse(ch))){

        setState(() {
          _mathProblem.nextProblem();
          _colorInput=Colors.green;
          _showTimeOperation();
        });

        if(_mathProblem.finished)
          _showResults(context);
        else{
          _showOperation();
          Future.delayed(Duration(milliseconds: 300+100*_mathProblem.getLevel()),(){
            setState(() {
              this._controllerField.text='';
              _colorInput=Colors.black54;
            });
          });
        }
      }
      else{
        //Only when submitted (entered pressed) give feedback that answer is wrong
        if (submitted){
          setState(() {
            _colorInput=Colors.red;
          });
          Future.delayed(Duration(milliseconds: 300+120*_mathProblem.getLevel()),(){
            setState(() {
              this._controllerField.text='';
              _colorInput=Colors.black54;
            });
          });
        }else{
          _colorInput=Colors.black54;
        }
      }

  }

  void _showResults(BuildContext context){
    //update results
    widget._results.updateSave(_mathProblem.operations);
    widget.rankingSave.update(widget._results);
    //save results
    widget.savings.saveResults();
    widget.savings.saveRank();
    //Open results page
    Navigator.pushReplacementNamed(context, '/resultsPage');
  }

}