import 'package:flutter/material.dart';

getDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Row(
            children: [
              Icon(
                Icons.timelapse,
                color: Colors.white,
                size: 35,
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                'Mental Maths',
                style: TextStyle(fontSize: 25, color: Colors.white),
              )
            ],
          ),
        ),
        ListTile(
          title: Text('Train'),
          leading: Icon(Icons.timer),
          onTap: () {
            Navigator.pushReplacementNamed(
                context, "/startTrain");
          },
        ),
        ListTile(
          title: Text('Results'),
          leading: Icon(Icons.timeline),
          onTap: () {
            Navigator.pushReplacementNamed(
                context, "/allResultsPage");
          },
        ),
        ListTile(
          title: Text('Archived'),
          leading: Icon(Icons.inventory),
          onTap: () {
            Navigator.pushReplacementNamed(
                context, "/archived");
          },
        ),
        ListTile(
          title: Text('Global Ranking'),
          leading: Icon(Icons.g_mobiledata),
          onTap: () {
            Navigator.pushReplacementNamed(
                context, "/ranking");
          },
        ),
        ListTile(
          title: Text('Settings'),
          leading: Icon(Icons.settings),
          onTap: () {
            Navigator.pushReplacementNamed(
                context, "/config");
          },
        )
      ],
    ),
  );
}
