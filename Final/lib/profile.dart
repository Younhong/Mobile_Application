import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  final userID, email, url;
  ProfilePage({Key key, @required this. email, @required this.userID, @required this.url}) : super(key: key);
  ProfileState createState() => ProfileState(userID, email, url);
}

class ProfileState extends State <ProfilePage> {
  final userID, email, url;
  ProfileState(this.userID, this.email, this.url);

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {Navigator.pop(context);},
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));}
            )
          ],),
        body: Center(
          child: Column(
            children: <Widget> [
              Image.network(url, fit: BoxFit.contain, height: 240, width: 700),
              Container(padding: EdgeInsets.only(top: 20, left: 70, right: 70), child: Text(userID, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),),),
              Container(padding: EdgeInsets.only(top: 20, left: 20, right: 20), child: Text(email, style: TextStyle(color: Colors.white, fontSize: 20)),),
            ],
          ),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  void _signOut() async {
    await _auth.signOut();
  }
}