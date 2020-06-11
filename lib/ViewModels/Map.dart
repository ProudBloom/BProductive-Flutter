import 'dart:async';
import 'dart:collection';

import 'package:bproductiveflutter/Models/Todo.dart';
import 'package:bproductiveflutter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {

  var priorityItems = [1, 2, 3];
  String description = "";
  String localisation = "";
  int priority = 1;

  Set<Marker> markers = HashSet<Marker>();

  GoogleMapController mapController;
  static const center = const LatLng(51.759445, 19.457216);
  LatLng lastPosition = center;
  MapType currentMapType = MapType.normal;

  void onMapCreated(GoogleMapController controller)
  {
    mapController = controller;

    Firestore.instance.collection('Todos').getDocuments().then( (docs) {
      if(docs.documents.isNotEmpty)
        {
          for(int i = 0; i < docs.documents.length; i++)
            {
              Todo task = new Todo(docs.documents[i].data['description'], int.parse(docs.documents[i].data['priority'].toString()), docs.documents[i].data['localisation']);
              placeMarker(task);
            }
        }
    });
  }

  void onCameraMove(CameraPosition position)
  {
      lastPosition = position.target;
  }

  void addMarkerOnLocation(Todo task)
  {
    print(lastPosition.toString());
    print(lastPosition.toString().substring(7, 43));
    task.localisation = lastPosition.toString().substring(7, 43);

    setState(() {
      markers.add(Marker(
          markerId: MarkerId(lastPosition.toString()),
          position: lastPosition,
        infoWindow: InfoWindow(title: task.text, snippet: 'Priority: ' + task.priority.toString()),
        icon: BitmapDescriptor.defaultMarker,
      ),
      );
    });
  }

  void placeMarker(Todo task)
  {
    int counter = 0;
    final stringPattern = RegExp(r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$');
    if(task.localisation.contains(stringPattern))
      {
        List<String> latlong = task.localisation.split(",");

        double latitude = double.parse(latlong[0]);
        double longitude = double.parse(latlong[1]);
        setState(() {
          markers.add(Marker(
            markerId: MarkerId(task.localisation),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: task.text, snippet: 'Priority: ' + task.priority.toString()),
            icon: BitmapDescriptor.defaultMarker,
          ));
        });
      }
    else
      {
        counter++;
        markers.add(Marker(
          markerId: MarkerId(counter.toString()),
          position: center,
          infoWindow: InfoWindow(title: task.text, snippet: 'Priority: ' + task.priority.toString() + ', in ' + task.localisation),
          icon: BitmapDescriptor.defaultMarker,
        ));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: 12,
            ),
            markers: markers,
            mapType: currentMapType,
            onCameraMove: onCameraMove,
            //myLocationButtonEnabled: true,
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 50),
            child: Text(
                'Navigate to a location to add the task',
                style: TextStyle(color: MyApp.accent_color, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              alignment: Alignment.center,
              child: Icon(Icons.add, color: MyApp.accent_color,)
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder:
              (BuildContext context){
            return AlertDialog(
              content: Container(
                height: 200,
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: 'Task: '),
                      onChanged: (String desc){
                        description = desc;
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                            child: Text('Priority : '),
                          ),
                          DropdownButton<int>(
                            value: priority,
                            items: priorityItems.map((element) {
                              return DropdownMenuItem<int>(
                                value: element,
                                child: Text(
                                  element.toString(),
                                  textAlign: TextAlign.center,),
                              );
                            }).toList(),
                            onChanged: (int value) {
                              priority = value;
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Todo temp = new Todo(description, priority, localisation);
                    addMarkerOnLocation(temp);
                    temp.addTodo();
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'),)
              ],
            );
          });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
