import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'dart:async';

getDrawer(BuildContext context){
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(decoration: BoxDecoration(color:Colors.blue),child: Row(
          children: [
            Icon(Icons.timelapse,color: Colors.white,size: 35,),
            SizedBox(width: 7,),
            Text('Mental Maths',style: TextStyle(fontSize: 25,color: Colors.white),)
          ],
        ),),
        ListTile(
          title: Text('Train'),
          leading: Icon(Icons.timer),
          onTap: (){Navigator.pushNamedAndRemoveUntil(context, "/startTrain", (r) => false);},
        ),
        ListTile(
          title: Text('Results'),
          leading: Icon(Icons.timeline),
          onTap: (){Navigator.pushNamedAndRemoveUntil(context, "/allResultsPage", (r) => false);},
        ),
      ],
    ),
  );
}