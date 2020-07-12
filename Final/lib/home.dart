import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add.dart';
import 'profile.dart';
import 'record.dart';
import 'detail.dart';

String dropdownValue = 'ASC';

class HomePage extends StatefulWidget {
  final userID, email, url;
  HomePage({Key key, @required this. email, @required this.userID, this.url}) : super(key: key);
  HomeState createState() => HomeState(userID, email, url);
}

class HomeState extends State<HomePage> {
  final userID, email, url;
  HomeState(this.userID, this.email, this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                    ProfilePage(userID: userID, email: email, url: url)));
          },
        ),
        title: Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      AddPage(userID: userID)));
            },
          ),
        ],
      ),
      body:  ListView(
        children: <Widget>[
          Container(
            height: 120,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 50),
            child: DropdownButton(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 1,
              onChanged: (String newValue) {
                setState(() { dropdownValue = newValue;});
              },
              items: <String>['ASC', 'DESC']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value, child: Text(value),
                    );
              }).toList(),
            ),
          ),
          _buildBody(context, dropdownValue),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildBody(BuildContext context, String dropdownValue) {
      if (dropdownValue == "ASC") {
        return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("ShoppingList")
              .orderBy("price", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            return _buildList(context, snapshot.data.documents);
          },
        );
      }
    else
      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("ShoppingList")
            .orderBy("price", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildList(context, snapshot.data.documents);
        },
      );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GridView.count (
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data){
    final record = Record.fromSnapshot(data);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Image.network(
              '${record.image}',
              fit: BoxFit.contain,
              width: 200,
              height: 110,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top:10, left: 20),
            child: Text(
              record.name,
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
              softWrap: true,
            ),),
          Container(
            padding: const EdgeInsets.only(top:2, left: 20),
            child: Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      record.price.toString(),
                      style: TextStyle(fontSize: 9.0),
                      softWrap: true,
                    ),)
                ]
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 100),
            child: Column(
              children: <Widget>[
                FlatButton(
                  child: Text('More',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue),),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          DetailPage(record: record, userID: userID, docID: data.documentID))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}