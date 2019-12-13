import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String name;
  final String url;

  Song({this.name, this.url});

  factory Song.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Song(
      name: data["name"],
      url: data["url"]
    );
  }

  factory Song.fromMap(Map data) {
    data = data ?? { };

    return Song(
        name: data["name"],
        url: data["url"]
    );
  }
}