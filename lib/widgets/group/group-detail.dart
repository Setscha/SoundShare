import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:soundshare/models/Group.dart';
import 'package:soundshare/models/User.dart';
import 'package:soundshare/services/db.dart';
import 'package:soundshare/services/info-overlay.dart';
import 'package:soundshare/widgets/player/group-player.dart';
import 'package:soundshare/widgets/group/group-userlist.dart';
import 'package:provider/provider.dart';
import 'package:soundshare/widgets/player/player_history.dart';

class GroupDetail extends StatefulWidget {
  final index;
  GroupDetail({this.index});
  @override
  _GroupDetail createState() => _GroupDetail();
}
enum GroupAction { edit, leave, delete}

class _GroupDetail extends State<GroupDetail> {

  @override
  Widget build(BuildContext context) {
    //FIXME: Provider not found
    Group group = Provider.of<Group>(context);
    User user = Provider.of<User>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(group.title),
          actions: <Widget>[
            GroupMenu(uid: user.uid, group: group)
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.insert_chart)),
              Tab(icon: Icon(Icons.group))
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GroupPlayer(),
            PlayerHistory(),
            GroupUserList()
          ],
        ),
      ),
    );
  }
}

class GroupMenu extends StatelessWidget {
  final Group group;
  final String uid;
  GroupMenu({this.uid, this.group});


  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<GroupAction>(
      onSelected: (GroupAction result) async {
        if(result == GroupAction.leave){
          try {
            final HttpsCallable leave = cloudFunctionInstance.getHttpsCallable(
                functionName: "leaveGroup"
            );
            dynamic resp = await leave.call(<String, dynamic>{
              "groupid": group.id
            });
            if (resp.data["status"] == "Failed") {
              InfoOverlay.showErrorSnackBar("Fehler beim Verlassen der Gruppe");
            } else {
              InfoOverlay.showInfoSnackBar("Gruppe verlassen");
              Navigator.pop(context);
            }
          }catch(e) {
            InfoOverlay.showErrorSnackBar("Fehler: ${e.message}");
          }
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<GroupAction>>[
        PopupMenuItem<GroupAction>(
          value: GroupAction.edit,
          enabled: group.creator.uid == uid,
          child: Text('Gruppe bearbeiten'),
        ),
        PopupMenuItem<GroupAction>(
          value: GroupAction.delete,
          enabled: group.creator.uid == uid,
          child: Text('Gruppe löschen'),
        ),
        PopupMenuItem<GroupAction>(
          value: GroupAction.leave,
          child: Text('Gruppe verlassen'),
        ),
      ],
    );
  }

}