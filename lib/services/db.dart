import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rxdart/rxdart.dart';
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

  Stream<List<Group>> streamGroupsFromUser(String uid) {
    print("----- READ GROUPS -----");
    return Observable(_db
        .collection("groups_user")
        .document(uid)
        .snapshots()).switchMap((DocumentSnapshot snap) {
      if(snap.data == null || snap.data["groups"] == null || snap.data["groups"].length == 0){
        return Stream.value(List<Group>.from([]));
      }
      return _db
          .collection("groups")
          .where(FieldPath.documentId, whereIn: snap.data["groups"])
          .snapshots()
          .map((snap) => snap.documents.map((d) => Group.fromFirestore(d)).toList());
    });
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
        .setData({"songs": FieldValue.arrayUnion([{"name": song.name, "url": song.url}])}, merge: true);
  }

}


final databaseService = DatabaseService();
final cloudFunctionInstance = CloudFunctions(app: FirebaseApp(name: "[DEFAULT]"), region: "europe-west1");
