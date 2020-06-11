import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

import '../main.dart';

class TimerPage extends StatefulWidget{
  @override
  _TimerPageState createState() {
    return _TimerPageState();
  }
}

class _TimerPageState extends State<TimerPage>{
  int initTime;
  bool started = false;
  int time = 15;  //seconds
  int studyTime = 15; //seconds
  int breakTime = 5; //seconds
  String timeLeftText = "00:00";
  String txt = "";
  bool stopTimer = false;
  bool timeToBreak = true;
  int timeLeft;
  int session = 0;
  int breaks = 0;
  int totalSessionsStats;
  double totalTimeStats;
  Timer _timer;

  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(250.0, 250.0);

  List<CircularStackEntry> _generateChartData(int sec){
    List<CircularStackEntry> data = [
      new CircularStackEntry(
        <CircularSegmentEntry>
        [new CircularSegmentEntry(timeToBreak?(sec*(100/studyTime)).toDouble():(sec*(100/breakTime)).toDouble(), MyApp.secondary_color)])
    ];
    return data;
  }

  void updateTotalSessions(int value)
  {
    Firestore.instance.collection('Stats').getDocuments().then( (docs) {
      if(docs.documents.isNotEmpty)
      {
        value = docs.documents[0].data['TakenSessions'];  //Load
        value++;                                          //Modify
        print('Taken Sessions : ' + value.toString());

        Map<String, dynamic> mapTakenSessions = {
          'TakenSessions': value
        };

        updateData(mapTakenSessions); //Update database
      }
    });
  }

  void updateTotalTime(double value)
  {
    Firestore.instance.collection('Stats').getDocuments().then( (docs) {
      if(docs.documents.isNotEmpty)
      {
        value = docs.documents[0].data['HoursSpentLearning'].toDouble();  //Load
        value += 0.25;                                         //Modify (15 min - studyTime)
        print('Hours spent : ' + value.toString());

        Map<String, dynamic> mapTotalTime = {
          'HoursSpentLearning': value
        };

        updateData(mapTotalTime); //Update database
      }
    });
  }

  updateData(newValue)
  {
    Firestore.instance.collection('Stats').document('yK7VqYKX0frFN8Cn3XZo').updateData(newValue).catchError( (e)
    {
      print(e);
    });
  }


  void start(){
    setState(() {
      stopTimer = false;
      started = true;
      txt = "Study hard!";
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer){
        setState(() {
          if(time < 1 && session < 4 && timeToBreak){
            timeToBreak = false;
            timeLeftText = "";
            time = breakTime;
            updateTotalTime(totalTimeStats);
            List<CircularStackEntry> data = _generateChartData(time);
            session++;
            breaks++;
            //debugPrint(breaks.toString()+ "break Time");
            //debugPrint(totalTimeStats.toString() + "total time");
            txt = "Take a short break!";
          }

          else if(time < 1 && session < 4 && !timeToBreak){
            timeToBreak = true;
            time = studyTime;
            List<CircularStackEntry> data = _generateChartData(time);
            //debugPrint(session.toString()+ "study Time");

            txt = "Study hard!";
          }

          else if(time < 1 && session == 4){
            session = 0;
            breaks = 0;
            timeToBreak = true;
            updateTotalSessions(totalSessionsStats);
            _timer.cancel();
            stopTimer = true;
            timeLeftText = "";
            time = studyTime;
            started = false;
          }

          else{
            time = time - 1;
            List<CircularStackEntry> data = _generateChartData(time);
            _chartKey.currentState.updateData(data);
          }

          if(time >= 60){
            int m = time ~/ 60;
            int s = time - (60*m);
            if(m < 10 && s >= 10){
              timeLeftText = "0" + m.toString() + ":" + s.toString();
              List<CircularStackEntry> data = _generateChartData(time);
            }
            else if(s < 10 && m < 10){
              timeLeftText = "0" + m.toString() + ":0" + s.toString();
              List<CircularStackEntry> data = _generateChartData(time);
            }
            else{
              timeLeftText = m.toString() + ":" + s.toString();
              List<CircularStackEntry> data = _generateChartData(time);
            }
          }
          else if(time < 60 && time >= 10){
            timeLeftText = "00:" + time.toString();
            List<CircularStackEntry> data = _generateChartData(time);
          }
          else if(time < 10){
            timeLeftText = "00:0" + time.toString();
            List<CircularStackEntry> data = _generateChartData(time);
          }
        });

    });
  }

  void pause(){
    setState(() {
      started = false;
      _timer.cancel();
      //debugPrint("pause" + time.toString());
    });
  }

  void stop(){
      setState(() {
        stopTimer = true;
        _timer.cancel();
        timeToBreak = true;
        started = false;
        time = studyTime;
        timeLeftText = "";
        breaks = 0;
        session = 0;
        //debugPrint("Timerstopped");
      });


  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: session == 0 ? Icon(Icons.radio_button_unchecked, color: MyApp.accent_color,) : Icon(Icons.brightness_1, color: MyApp.accent_color,),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: session < 2 ? Icon(Icons.radio_button_unchecked, color: MyApp.accent_color,) : Icon(Icons.brightness_1, color: MyApp.accent_color,),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: session < 3 ? Icon(Icons.radio_button_unchecked, color: MyApp.accent_color,) : Icon(Icons.brightness_1, color: MyApp.accent_color,),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: session < 4 ? Icon(Icons.radio_button_unchecked, color: MyApp.accent_color,) : Icon(Icons.brightness_1, color: MyApp.accent_color,),
                      )
                    ],
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Center(
                      child: Text(
                        txt,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: MyApp.secondary_color,
                        ),
                      )
                  ),
                )
              ],
            ),

            Container(
              margin: const EdgeInsets.only(top: 10),
              child: new AnimatedCircularChart(
                key: _chartKey,
                size: _chartSize,
                initialChartData: _generateChartData(time),
                chartType: CircularChartType.Radial,
                edgeStyle: SegmentEdgeStyle.round,
                percentageValues: true,
                holeLabel: timeLeftText ,
                labelStyle: TextStyle(color: MyApp.secondary_color, fontSize: 30),
              ),
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    height: 40,
                    width: 70,
                    margin: EdgeInsets.only(top: 20),
                    child: FlatButton(
                      child: Image.asset(started ? 'assets/pause.png' : 'assets/play.png'),
                      onPressed: started ? pause : start,
                    )
                ),
                Container(
                    height: 40,
                    width: 70,
                    margin: EdgeInsets.only(top: 20),
                    child: FlatButton(
                      child: Image.asset('assets/stop.png'),
                      onPressed: stop,
                    )
                )
              ],
            )
          ],
        )
    );
  }
}