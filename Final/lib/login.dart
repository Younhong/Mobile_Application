import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class SignInPage extends StatefulWidget {
  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
            SizedBox(height: 200.0),
            Column(
              children: <Widget>[
                Image.asset('assets/diamond.png')
              ],
            ),
            SizedBox(height: 90.0),
            _GoogleSignInSection(),
            _AnonymouslySignInSection(),
          ],
        );
      }),
    );
  }
}

class _AnonymouslySignInSection extends StatefulWidget {
  @override
  _AnonymouslySignInSectionState createState() => _AnonymouslySignInSectionState();
}

class _AnonymouslySignInSectionState extends State<_AnonymouslySignInSection> {

  String url;
  String userID;
  String email;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 360,
          child: FlatButton(
            color: Colors.grey,
            onPressed: () async {
              final FirebaseUser user = (await _auth.signInAnonymously());
              assert(user != null);
              assert(user.isAnonymous);
              assert(!user.isEmailVerified);
              assert(await user.getIdToken() != null);
              if (Platform.isIOS) {
                assert(user.providerData.isEmpty);
              } else if (Platform.isAndroid) {
                assert(user.providerData.length == 1);
                assert(user.providerData[0].providerId == 'firebase');
                assert(user.providerData[0].uid != null);
                assert(user.providerData[0].displayName == null);
                assert(user.providerData[0].photoUrl == null);
                assert(user.providerData[0].email == null);
              }

              final FirebaseUser currentUser = await _auth.currentUser();
              assert(user.uid == currentUser.uid);
              setState(() {
                if (user != null) {
                  userID = user.uid;
                  email = 'anonymous';
                  url = 'https://firebasestorage.googleapis.com/v0/b/final-exam-de688.appspot.com/o/empty.png?alt=media&token=3e61e669-7b93-4089-8791-d17d844a67cb';
                }
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userID: userID, email: email, url: url)));
            },
            child: Row(
              children: <Widget>[
                Text('?     ', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                Text('Guest', style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GoogleSignInSection extends StatefulWidget {
  @override
  _GoogleSignInSectionState createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection> {
  String url;
  String userID;
  String email;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 360,
          child: FlatButton(
            color: Colors.red,
            onPressed: () async {

              final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
              final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
              final AuthCredential credential = GoogleAuthProvider.getCredential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
              );
              final FirebaseUser user =
              (await _auth.signInWithCredential(credential));
              assert(user.email != null);
              assert(user.displayName != null);
              assert(!user.isAnonymous);
              assert(await user.getIdToken() != null);

              final FirebaseUser currentUser = await _auth.currentUser();
              assert(user.uid == currentUser.uid);
              setState(() {
                if (user != null) {
                  userID = user.uid;
                  email = user.email;
                  url = user.photoUrl;
                }
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userID: userID, email: email, url: url)));
            },
            child: Row(
              children: <Widget>[
                Text('G    ', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                Text('Google', style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
        ),
      ],
    );
  }
}