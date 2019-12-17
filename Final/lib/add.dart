import 'package:flutter/material.dart';
import 'record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

var imageURL = 'http://handong.edu/site/handong/res/img/logo.png';
final FirebaseStorage storage = FirebaseStorage(storageBucket: 'gs://final-exam-de688.appspot.com');

class AddPage extends StatefulWidget {

  final userID;
  AddPage({Key key, @required this.userID}) : super(key: key);

  AddState createState() => AddState(userID);
}

class AddState extends State<AddPage> {
  final userID;
  AddState(this.userID);
  File imageFile;

  final title = 'Add';
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  Record record;
  final _formKey = GlobalKey<FormState>();
  final DateTime currentTime = new DateTime.now();

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: FlatButton(
            child: Text('Cancel', style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold),),
            onPressed: () {
              _nameController.clear();
              _priceController.clear();
              _descriptionController.clear();
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Save'),
              onPressed: () async {
                if (imageFile != null) {
                  String fileName = basename(imageFile.path);
                  StorageReference fireBaseStorageRef = storage.ref().child(
                      fileName);
                  StorageUploadTask uploadTask = fireBaseStorageRef.putFile(
                      imageFile);
                  StorageTaskSnapshot taskSnapshot = await uploadTask
                      .onComplete;
                  imageURL = await taskSnapshot.ref
                      .getDownloadURL() as String;
                }

                if (_formKey.currentState.validate()) {
                  Firestore.instance.collection("ShoppingList").add({"name": _nameController.text, "price": int.parse(_priceController.text), "description": _descriptionController.text, "like": 0,
                    'uid': userID, 'created': currentTime, 'modified': currentTime, 'favorite': FieldValue.arrayUnion([]), 'image': imageURL.toString()});
                  _nameController.clear();
                  _priceController.clear();
                  _descriptionController.clear();
                  imageURL = 'http://handong.edu/site/handong/res/img/logo.png';
                  Navigator.pop(context);
                }
              }
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget> [
              Column(
                children: <Widget>[
                  (imageFile == null) ? Image.network('https://firebasestorage.googleapis.com/v0/b/final-exam-de688.appspot.com/o/empty.png?alt=media&token=3e61e669-7b93-4089-8791-d17d844a67cb', fit: BoxFit.cover, height: 240, width: 700)
                      : Image.file(imageFile, fit: BoxFit.contain, height: 240, width: 700),
                ],
              ),
              IconButton(
                  padding: EdgeInsets.only(left: 350),
                  icon: Icon(Icons.camera_alt, color: Colors.black,),
                  onPressed: () {
                    chooseFile();
                  },
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Username';
                  }
                  return null;
                },
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Product Name',
                ),
                style: TextStyle(color: Colors.blue),
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter price';
                  }
                  return null;
                },
                controller: _priceController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Price',
                ),
                style: TextStyle(color: Colors.blue),
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter description';
                  }
                  return null;
                },
                controller: _descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Description',
                ),
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      ),);}

  Future chooseFile() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageFile = image;
    });
  }
}