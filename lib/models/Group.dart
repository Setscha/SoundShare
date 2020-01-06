import 'package:cloud_firestore/cloud_firestore.dart';
import 'PublicUser.dart';
import 'Song.dart';


class Group {
  final String title;
  final PublicUser creator;
  final List<PublicUser> members;
  final List<String> history;
  final List<Song> songs;
  final String id;
  final Timestamp created;
  String currentURL;
  String currentName;
  bool playing;
  bool paused;

  Group({this.title, this.creator, this.members, this.id, this.history, this.songs, this.created, this.currentName, this.currentURL, this.paused, this.playing});

  factory Group.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data ?? { };

    return Group(
        id: doc.documentID,
        title: data["title"],
        creator: PublicUser.fromMap(data["creator"]),
        history: List.from(data["history"] ?? []),
        members: List.from(data["members"] ?? []).map((member) => PublicUser.fromMap(member)).toList(),
        songs: List.from(data["songs"] ?? []).map((song) => Song.fromMap(song)).toList(),
        created: data["created"],
        playing: data["playing"] ?? false,
        paused: data["paused"] ?? false,
        currentName: data["currentName"],
        currentURL: data["currentURL"]
    );
  }

  factory Group.fromMap(Map data) {
    if(data == null)
      return null;
    data = data ?? { };
//    print(data["members"]);
    return Group(
        title: data["title"],
        creator: PublicUser.fromMap(data["creator"]),
        history: List.from(data["history"] ?? []),
        members: List.from(data["members"] ?? []).map((member) => PublicUser.fromMap(member)).toList(),
        songs: List.from(data["songs"] ?? []).map((song) => Song.fromMap(song)).toList(),
        created: data["created"],
        playing: data["playing"],
        paused: data["paused"],
        currentName: data["currentTitle"],
        currentURL: data["currentURL"]
    );
  }
}