import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_player/music_player.dart';
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

  MusicPlayer musicPlayer;
  bool playing = false;
  bool paused = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    print(paused);
  }

  // Initializing the Music Player and adding a single [PlaylistItem]
  Future<void> initPlatformState() async {
    musicPlayer = MusicPlayer();
  }


  @override
  void dispose() {
    super.dispose();
    musicPlayer.stop();
  }

  void changeSong(String url) {
    musicPlayer.play(
        MusicItem(
            trackName: 'Knossi King',
            albumName: 'Sample Album',
            artistName: 'Sample Artist',
            url: url,
            duration: Duration()
        )
    );
  }

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
            GroupPlayer(notifyParent: changeSong,),
            PlayerHistory(notifyParent: changeSong,),
            GroupUserList()
          ],
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Row(
            children: [
              Text(
                "sadas",
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              IconButton(
                icon: Icon(paused ? Icons.play_arrow : Icons.pause),
                onPressed: () {
                  if(!playing || paused) {
                    if(paused && playing) {
                      print("resuming");
                      musicPlayer.resume();
                      setState(() {
                        paused = false;
                      });
                    }else {
                      print("playing");
                      musicPlayer.play(
                          MusicItem(
                              trackName: 'Knossi King',
                              albumName: 'Sample Album',
                              artistName: 'Sample Artist',
                              url: 'https://firebasestorage.googleapis.com/v0/b/listassist-433b3.appspot.com/o/Knossi_%C3%BCberf%C3%A4llt_eine_Tankstelle.mp3?alt=media&token=98bb0f97-1103-4265-9059-6774008bc4e7',
                              coverUrl: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.qR8pkpLCrJ4gmSI3m-SsRgHaKY%26pid%3DApi&f=1',
                              duration: Duration(seconds: 30)
                          )
                      );
                      setState(() {
                        playing = true;
                        paused = false;
                      });
                    }
                  }else {
                    print("stopping");
                    musicPlayer.pause();
                    setState(() {
                      paused = true;
                    });
                  }
                }
              ),
            ]
          ),
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
        }else if(result == GroupAction.delete) {
          try {
            final HttpsCallable delete = cloudFunctionInstance.getHttpsCallable(
                functionName: "deleteGroup"
            );
            dynamic resp = await delete.call(<String, dynamic>{
              "groupid": group.id
            });
            if (resp.data["status"] == "Failed") {
              InfoOverlay.showErrorSnackBar("Fehler beim Löschen der Gruppe");
            } else {
              InfoOverlay.showInfoSnackBar("Gruppe gelöscht");
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
