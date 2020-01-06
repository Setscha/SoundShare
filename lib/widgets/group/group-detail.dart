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
  Group _group;

  @override
  void initState() {
    super.initState();
    initPlatformState();
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

  void changeSong(String url, String name) {
    print(url);
    _group.playing = true;
    _group.paused = false;
    _group.currentName = name;
    _group.currentURL = url;
    databaseService.updateGroup(_group);
    setState(() {
    });
    musicPlayer.play(
        MusicItem(
            trackName: _group.currentName,
            albumName: 'Sample Album',
            artistName: 'Sample Artist',
            url: _group.currentURL,
            coverUrl: 'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.qR8pkpLCrJ4gmSI3m-SsRgHaKY%26pid%3DApi&f=1',
            duration: Duration()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    _group = Provider.of<List<Group>>(context)[widget.index];
    print(_group.currentName);
    User user = Provider.of<User>(context);

    return _group == null ? Container() : DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(_group.title),
          actions: <Widget>[
            GroupMenu(uid: user.uid, group: _group)
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
            GroupPlayer(notifyParent: changeSong, index: widget.index),
            PlayerHistory(notifyParent: changeSong, index: widget.index),
            GroupUserList(index: widget.index)
          ],
        ),
        bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Row(
            children: [
              Text(
                _group.currentName ?? 'Select a Song',
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
              IconButton(
                icon: Icon(_group.paused ? Icons.play_arrow : Icons.pause),
                onPressed: () {
                  if(!_group.playing || _group.paused) {
                    if(_group.paused && _group.playing) {
                      print("resuming");
                      musicPlayer.resume();
                      setState(() {
                        _group.paused = false;
                      });
                    }
                  }else {
                    print("stopping");
                    musicPlayer.pause();
                    setState(() {
                      _group.paused = true;
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
