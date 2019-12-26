import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:soundshare/models/Group.dart';
import 'package:soundshare/models/Invite.dart';
import 'package:soundshare/models/Song.dart';
import 'package:soundshare/models/User.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<User> streamProfile(FirebaseUser user) {
    print("READ USER");
    return _db
        .collection("users")
        .document(user.uid)
        .snapshots()
        .map((snap) => User.fromMap(snap.data));
  }

  Stream<List<Stream<Group>>> streamGroupsFromUser(String uid) {
    print(uid);
    return _db
        .collection("groups_user")
        .document(uid)
        .snapshots()
        .map((list) {
      return list.data != null ? list.data["groups"]
          .map<Stream<Group>>((groupId) => _db
          .collection("groups")
          .document(groupId)
          .snapshots()
          .map<Group>((snap) => Group.fromFirestore(snap))
      ).toList() : List<Stream<Group>>();
    });

//    return _db
//        .collection("groups_user")
//        .document(uid)
//        .snapshots()
//        .map<List<Group>>((list) {
//          print(list);
//          print(list.data);
//          return list.data != null ? list.data["groups"]
//          .map<Stream<Group>>((groupId) => _db
//            .collection("groups")
//            .document(groupId)
//            .snapshots()
//            .map<Group>((snap) => Group.fromMap(snap.data))
//          ).toList() : List<Group>();
//    });

//    return db
//            .collection("groups")
//            .document('89XF5ZpygJtmMxWQ0Weo')
//            .snapshots()
//            .map((snap) => Group.fromMap(snap.data));
  }

  Stream<List<Invite>> streamInvites(String uid) {
    return _db
        .collection("invites")
        .where("to", isEqualTo: uid)
        .where("type", isEqualTo: "pending")
        .snapshots()
        .map((snap) => snap.documents.map((d) => Invite.fromFirestore(d)).toList());
  }

  Future<void> updateProfileName(String uid, String newName) {
    return _db
        .collection('users')
        .document(uid)
        .updateData({'displayName': newName});
  }

  Future<void> updateEmail(String uid, String newEmail) {
    return _db
        .collection('users')
        .document(uid)
        .updateData({'email': newEmail});
  }


  Future<void> addSongToGroup(Group group, Song song) {
    return _db
        .collection("groups")
        .document(group.id)
        .setData({"songs": FieldValue.arrayUnion([{"name": song.name, "url": song.url}])});
  }

}


final databaseService = DatabaseService();
final cloudFunctionInstance = CloudFunctions(app: FirebaseApp(name: "[DEFAULT]"), region: "europe-west1");
