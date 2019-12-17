import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  final String name;
  final int price;
  final String description;
  final String image;
  final int like;
  final String uid;
  final DocumentReference reference;
  final Timestamp created;
  final Timestamp modified;
  final List favorite;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['price'] != null),
        assert(map['description'] != null),
        assert(map['image'] != null),
        assert(map['like'] != null),
        assert(map['uid'] != null),
        assert(map['created'] != null),
        assert(map['modified'] != null),
        name = map['name'],
        price = map['price'],
        description = map['description'],
        image = map['image'],
        like = map['like'],
        uid = map['uid'],
        created = map['created'],
        modified = map['modified'],
        favorite = map['favorite'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$price:$description:$image:$like:$created:$modified>";
}