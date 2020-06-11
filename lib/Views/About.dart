import 'package:flutter/material.dart';
import '../main.dart';

class About extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
          children: <Widget>[
            Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                          "BProductive ver: 0.2",
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.black45,
                          ),
                        )
                  )
                ]
            ),

            Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    "Developed by:\n Jakub Sztompka 100731 \n Mateusz Roganowicz 96947",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black45,
                    ),
                  ),
                )
              ],
            ),

            Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 30, left: 10),
                  child: Text(
                    "App was designed and implemented \nfor ICM course at \nUniversity of Aveiro (2019/2020)",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black45,
                    ),
                  ),
                )
              ],
            ),

            Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 200, left: 10),
                  child: Text(
                    "All icons were downloaded from \nhttps://www.flaticon.com/",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black45,
                    ),
                  ),
                )
              ],
            )


          ]
    )
    );
  }
}