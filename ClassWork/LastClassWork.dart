import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Names',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baby Name Votes')),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(
                child: Text('Add a new baby name',),
              ),
              content:
              SingleChildScrollView(
                child: ListBody(
                children: <Widget>[
                  Container(
                    child: TextFormField(
                      controller: myController,
                    ),
                  ),
                  Container(
                    width: 20,
                    padding: EdgeInsets.only(top: 30, left: 170),
                    child: FlatButton(
                      child: Text('Auto', style: TextStyle(color: Colors.blue)),
                      onPressed: () {
                        Firestore.instance.collection("baby").add({"name": myController.text, "votes": 0, "dislike": 0 });
                        Navigator.pop(context);
                        myController.clear();
                      }
                    ),
                  ),
                ],
              ),),
            );
          },);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 15),
          height: 80,
          child: Row(
            children: <Widget>[
              Container(
                width: 30,
                child: IconButton(icon: Icon(Icons.delete), onPressed: () => record.reference.delete()),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                width: 140,
                child: Text(record.name, style: TextStyle(fontSize: 20)),),
              Container(
                padding: const EdgeInsets.only(left: 90),
                child: Column(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.thumb_up, size: 22), onPressed: () => record.reference.updateData({'votes': FieldValue.increment(1)}),),
                    Text(record.votes.toString(), style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.thumb_down, size: 22), onPressed: () => record.reference.updateData({'dislike': FieldValue.increment(1)}),),
                    Text(record.dislike.toString(), style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Record {
  final String name;
  final int votes;
  final int dislike;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        assert(map['dislike'] != null),
        name = map['name'],
        votes = map['votes'],
        dislike = map['dislike'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes>";
}