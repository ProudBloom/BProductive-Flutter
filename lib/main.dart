import 'dart:async';
import 'package:flutter/material.dart';

import 'ViewModels/Mood.dart';
import 'ViewModels/Timer.dart';
import 'ViewModels/Music.dart';
import 'ViewModels/ToDoList.dart';
import 'Views/About.dart';
import 'ViewModels/Stats.dart';
import 'ViewModels/Map.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget
{
  static const main_color = Color(0xFFFFD300);
  static const main_color_secondary = Color(0xFFffa500);
  static const secondary_color = Color(0xFF2F9599);
  static const accent_color = Color(0xFFEC2049);
  static const green = Color(0xFF00c05f);


  @override
  State<StatefulWidget> createState()
  {
    return HomePage();
  }
}

class HomePage extends State<MyApp> {
  int _selectedIndex = 0;

  final _widgetOptions = [
    TimerPage(),
    MoodPage(),
    MusicPage(),
    ToDoListPage(),
    About(),
    Stats(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes:
        {
          '/map': (context) => Map(),
          '/todo': (context) => ToDoListPage(),
        },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("BProductive"),
          backgroundColor: MyApp.main_color,
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: MyApp.main_color,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.access_time), title: Text("Timer")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.mood), title: Text("Mood")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.music_note), title: Text("Music")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), title: Text("ToDoList")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.info), title: Text("About")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assessment), title: Text("Stats")
              ),
            ]),
      ),
    );
  }
}
