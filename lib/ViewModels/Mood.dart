import 'dart:collection';
import 'package:bproductiveflutter/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class MoodPage extends StatefulWidget {
  @override
  _MoodPageState createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {

  Map<String, int> moodCounters = {
    'Happy': 0,
    'Sad': 0,
    'Stressed': 0,
    'Normal': 0,
    'Angry': 0,
    'Confident': 0,
  };

  void updateMostCommonMood(Map <String, int> counters)
  {
    Firestore.instance.collection('Stats').getDocuments().then( (docs) {
      if(docs.documents.isNotEmpty)
      {
        var sortedKeys = counters.keys.toList(growable:false)..sort((k1, k2) => counters[k1].compareTo(counters[k2]));
        LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys, key: (k) => k, value: (k) => counters[k]);

        print(sortedMap);
        Map<String, dynamic> mapCommonMood = {
          'MostCommonMood': counters
        };

        //updateData(mapCommonMood); //Update database
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    "What is your mood today?",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: MyApp.secondary_color
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 100.0,
                height: 100.0,
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: (){moodCounters['Happy']++; updateMostCommonMood(moodCounters);},
                  child: Image.asset('assets/001-smile.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 100.0,
                height: 100.0,
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: (){moodCounters['Sad']++; updateMostCommonMood(moodCounters);},
                  child: Image.asset('assets/002-sad.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 100.0,
                height: 100.0,
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: (){moodCounters['Stressed']++; updateMostCommonMood(moodCounters);},
                  child: Image.asset('assets/012-stress.png'),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 100.0,
                height: 100.0,
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: (){moodCounters['Normal']++; updateMostCommonMood(moodCounters);},
                  child: Image.asset('assets/015-shock.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 100.0,
                height: 100.0,
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: (){moodCounters['Angry']++; updateMostCommonMood(moodCounters);},
                  child: Image.asset('assets/038-angry.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 100.0,
                height: 100.0,
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: (){moodCounters['Confident']++; updateMostCommonMood(moodCounters);},
                  child: Image.asset('assets/042-cool.png'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}