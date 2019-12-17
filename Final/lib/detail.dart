import 'package:flutter/material.dart';
import 'edit.dart';
import 'record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'record2.dart';

class DetailPage extends StatefulWidget {
  final Record record;
  final docID;
  final userID;
  DetailPage({Key key, @required this.record, @required this.userID, @required this.docID}) : super(key: key);

  DetailState createState() => DetailState(record, userID, docID);
}

class DetailState extends State<DetailPage> {
  final Record record;
  final docID;
  final userID;
  final title = 'Detail';
  DetailState(this.record, this.userID, this.docID);

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {Navigator.pop(context);},
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                if (record.uid == this.userID)
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(record: record)));
              }
            ),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  if (record.uid == this.userID) {
                    record.reference.delete();
                    Navigator.pop(context);
                  }
                })
          ],),
        body: SnackBarPage(record: record, userID: userID, docID: docID),
      ),);
  }
}

class SnackBarPage extends StatefulWidget {
  final Record record;
  final userID;
  final docID;
  SnackBarPage({Key key, @required this.record, @required this.userID, @required this.docID}) : super(key: key);

  SnackBarState createState() => SnackBarState(record, userID, docID);
}

class SnackBarState extends State<SnackBarPage>{
  final Record record;
  final userID;
  final docID;
  final title = 'Detail';
  SnackBarState(this.record, this.userID, this.docID);

  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    String docID = widget.docID;
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('ShoppingList').document(docID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildListItem(context, snapshot.data);
      },
    );
  }

  Widget _buildListItem(BuildContext context, snapshot) {
    final Record record = Record.fromSnapshot(snapshot);
    return ListView(
      children: [
        Container(
          child: Image.network(record.image, fit: BoxFit.contain, height: 240),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: <Widget>[
                      Container(
                        width: 250,
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          record.name,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top:3, bottom:3, right:3, left: 30),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.thumb_up),
                              color: (record.favorite.contains(userID) ? Colors.red : Colors.grey),
                              onPressed: () {
                                setState(() {
                                  if (record.favorite.contains(userID)) {
                                    final snackBar = SnackBar(
                                      content: Text('You can only do it once!!'),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  }
                                  else {
                                    record.reference.updateData({'like': FieldValue.increment(1)});
                                    record.reference.updateData({'favorite': FieldValue.arrayUnion([userID])});
                                    final snackBar = SnackBar(
                                      content: Text('I like it!'),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  }
                                });
                              },
                            ),
                            Text(record.like.toString())
                          ],
                        ),
                      ),
                    ],),
                    Container(
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text('${record.price}', style: TextStyle( color: Colors.blue, fontSize: 14,),
                            ),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1.0, color: Colors.black),
        Container(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            record.description,
            softWrap: true,
            style: TextStyle( color: Colors.blue, fontSize: 15),
          ),
        ),
        Column(
          children: <Widget>[
            Container(child: Text('Creator: ${record.uid}'),),
            Container(child: Text('Created at: ${record.created.toDate()}'),),
            Container(child: Text('Modified at: ${record.modified.toDate()}'),),
          ],
        ),
      ],
    );
  }
}