import 'package:cloud_firestore/cloud_firestore.dart';
import 'PublicUser.dart';
import 'Song.dart';


class Group {
  final String title;
  final PublicUser creator;
  final int memberCount;
  final List<PublicUser> members;
  final List<String> history;
  final List<Song> songs;
  final String id;
  final Timestamp created;

  Group({this.title, this.creator, this.memberCount, this.members, this.id, this.history, this.songs, this.created});

  factory Group.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data ?? { };

    return Group(
        id: doc.documentID,
        title: data["title"],
        creator: PublicUser.fromMap(data["creator"]),
        history: List.from(data["history"] ?? []),
        members: List.from(data["members"] ?? []).map((member) => PublicUser.fromMap(member)).toList(),
        songs: List.from(data["songs"] ?? []).map((song) => Song.fromMap(song)).toList(),
        created: data["created"]
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
        created: data["created"]
    );
  }
}