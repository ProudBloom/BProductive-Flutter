import 'package:cloud_firestore/cloud_firestore.dart';

class Todo
{
  String text;
  int priority;
  String localisation;

  Todo(String txt, int prior, String loc)
  {
    this.text = txt;
    this.priority = prior;
    this.localisation = loc;
  }

  addTodo()
  {
    DocumentReference documentReference = Firestore.instance.collection("Todos").document(text);

    //Map fields
    Map<String, dynamic> todos = {
      "description": text,
      "priority" : priority,
      "localisation": localisation,
    };
    documentReference.setData(todos).whenComplete( () { print("$text created"); } );
  }
}