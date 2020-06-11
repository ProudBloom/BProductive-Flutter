import 'package:bproductiveflutter/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ActivityBarChart extends StatelessWidget {
  final List<double> activity;

  const ActivityBarChart({@required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Monthly activity (entries per month)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height * 0.35),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10.0,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      rotateAngle: 35,
                      margin: 10.0,
                      showTitles: true,
                      textStyle: TextStyle(color: Colors.blueGrey, fontSize: 14.0, fontWeight: FontWeight.bold),
                      getTitles: (double value) {
                        switch(value.toInt())
                        {
                          case 0:
                            return 'Feb';
                          case 1:
                            return 'Mar';
                          case 2:
                            return 'Apr';
                          case 3:
                            return 'May';
                          case 4:
                            return 'Jun';
                          case 5:
                            return 'Jul';
                          case 6:
                            return 'Aug';
                          default:
                            return '';
                        }
                      }
                    ),
                    leftTitles: SideTitles(
                      margin: 10.0,
                      showTitles: true,
                      textStyle: TextStyle(color: Colors.blueGrey, fontSize: 14.0, fontWeight: FontWeight.bold),
                      getTitles: (value) {
                        if(value == 0) return '0';
                        else if (value % 3 == 0) return '${value ~/ 3 * 5}';
                        return '';
                      }
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    checkToShowHorizontalLine: (value) => value % 3 == 0,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.black26, strokeWidth: 1.0, dashArray: [5])
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: activity
                      .asMap()
                      .map( (key, value) => MapEntry(
                        key,
                        BarChartGroupData(
                          x: key,
                          barRods: [BarChartRodData(y:value, color: MyApp.accent_color)]
                        ),
                      ))
                      .values
                    .toList(),
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
