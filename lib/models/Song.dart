import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id;
  final String title;
  final String songurl;

  Song({this.id, this.title, this.songurl});

  factory Song.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Song(
      id: doc.documentID,
      title: data["title"],
      songurl: data["songurl"]
    );
  }

  factory Song.fromMap(Map data) {
    data = data ?? { };

    return Song(
        title: data["title"],
        songurl: data["songurl"]
    );
  }
}