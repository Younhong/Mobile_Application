import 'package:flutter/material.dart';
import 'record.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

final FirebaseStorage storage = FirebaseStorage(storageBucket: 'gs://final-exam-de688.appspot.com');

class EditPage extends StatefulWidget {
  final Record record;
  EditPage({Key key, @required this.record}) : super(key: key);
  EditState createState() => EditState(record);
}

class EditState extends State<EditPage> {
  File imageFile;

  final title = 'Edit';
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Record record;
  final _formKey = GlobalKey<FormState>();
  EditState(this.record);
  final DateTime currentTime = new DateTime.now();
  var downloadURL;

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: FlatButton(
            child: Text('Cancel',
              style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.bold),),
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
                onPressed: () async{
                  if (_formKey.currentState.validate()) {
                    if (imageFile != null) {
                      String fileName = basename(imageFile.path);
                      StorageReference fireBaseStorageRef = storage.ref().child(
                          fileName);
                      StorageUploadTask uploadTask = fireBaseStorageRef.putFile(
                          imageFile);
                      StorageTaskSnapshot taskSnapshot = await uploadTask
                          .onComplete;
                      downloadURL = await taskSnapshot.ref
                          .getDownloadURL() as String;
                    }
                    else
                      downloadURL = record.image;

                    record.reference.updateData({
                      "name": _nameController.text, "price": int.parse(_priceController.text),
                      "description": _descriptionController.text,
                      "modified": currentTime, 'image': downloadURL.toString()});
                    _nameController.clear();
                    _priceController.clear();
                    _descriptionController.clear();
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
                  (imageFile == null)
                      ? Image.network(
                        record.image,
                        fit: BoxFit.cover,
                        height: 240, width: 700)
                      : Image.file(
                        imageFile,
                        fit: BoxFit.contain,
                        height: 240, width: 700),
                ],
              ),
              IconButton(
                padding: EdgeInsets.only(left: 350),
                icon: Icon(Icons.camera_alt,
                  color: Colors.black,),
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
                  hintText: record.name,
                ),
                style: TextStyle(
                    color: Colors.blue),
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Price';
                  }
                  return null;
                },
                controller: _priceController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: '${record.price}',
                ),
                style: TextStyle(
                    color: Colors.blue),
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Description';
                  }
                  return null;
                },
                controller: _descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: record.description,
                ),
                style: TextStyle(
                    color: Colors.blue),
              ),
            ],
          ),
        ),
      ),);}

  Future chooseFile() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery);

    setState(() {
      imageFile = image;
    });
  }
}