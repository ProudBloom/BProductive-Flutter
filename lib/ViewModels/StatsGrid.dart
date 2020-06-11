import 'package:bproductiveflutter/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatsGrid extends StatefulWidget {
  @override
  _StatsGridState createState() => _StatsGridState();
}

class _StatsGridState extends State<StatsGrid> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:  Firestore.instance.collection('Stats').snapshots(),
      builder: (context, snapshot)
      {
        if(!snapshot.hasData) return Center(child: CircularProgressIndicator());
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width*0.95,
          child: Column(
            children: <Widget>[
                Row(
                  children: <Widget>[
                    statCard('Completed Todos', snapshot.data.documents[0]['CompletedTodos'].toString(), MyApp.secondary_color),
                    statCard('Hours spent learning', snapshot.data.documents[0]['HoursSpentLearning'].toString(), MyApp.secondary_color),
                  ],
                ),
              Row(
                  children: <Widget>[
                    statCard('Most common mood', snapshot.data.documents[0]['MostCommonMood'], MyApp.main_color_secondary),
                    statCard('Taken sessions', snapshot.data.documents[0]['TakenSessions'].toString(), MyApp.main_color_secondary),
                  ],
              )
            ],
          ),
        );
      }
    );
  }
}

Expanded statCard(String title, String value, Color color)
{
  return Expanded(
    child: Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: Text(
              value,
              style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    ),
  );
}