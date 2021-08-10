import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mental_maths/src/config.dart';
import 'package:mental_maths/src/math_op/file_control.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class KeyboardSizePage extends StatefulWidget {
  KeyboardSizePage({Key? key,required this.fileControl}) : super(key: key){
    uiSettings=fileControl.settings;
  }
  FileControl fileControl;
  late Settings uiSettings;
  @override
  _KeyboardSizePageState createState() => _KeyboardSizePageState();
}

class _KeyboardSizePageState extends State<KeyboardSizePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keyboard Size'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.fileControl.saveConfig();
            Navigator.pushReplacementNamed(context, "/config");
          }),
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

  Widget _getTrainerWidget(width, height) {
    /// Widget for training ///

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Operation card
        Card(
          child: SizedBox(
            width: width * 0.75,
            height: height * 0.36,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(height: 10,),
                    Text('Width : '+(widget.uiSettings.keyboardWidth.round().toString())+'%',style: TextStyle(color: Colors.black87,fontSize: 13),),
                      Slider(
                        value: widget.uiSettings.keyboardWidth,
                        onChanged: (ch) {
                          setState(() {
                            widget.uiSettings.keyboardWidth = ch;
                          });
                        },
                        max: 100,
                        min: 60,
                        label: widget.uiSettings.keyboardWidth.round().toString(),
                        divisions: 40,
                      ),
                    Text('Height : '+(widget.uiSettings.keyboardHeight.round().toString())+'%',style: TextStyle(color: Colors.black87,fontSize: 13),),
                    Slider(
                      value: widget.uiSettings.keyboardHeight,
                      onChanged: (ch) {
                        setState(() {
                          widget.uiSettings.keyboardHeight = ch;
                        });
                      },
                      max: 50,
                      min: 20,
                      label: widget.uiSettings.keyboardHeight.round().toString(),
                      divisions: 30,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        //Separation
        SizedBox(width: 10, height: 30),
        //Keyboard
        Container(
          child: VirtualKeyboard(
            height: height * (widget.uiSettings.keyboardHeight/100),
            width: (widget.uiSettings.keyboardWidth/100) * width,
            textColor: Colors.black54,
            fontSize: 20,
            defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
            type: VirtualKeyboardType.Numeric,
          ),
        )
      ],
    );
  }
}