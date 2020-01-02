import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:soundshare/models/Group.dart';
import 'package:soundshare/models/PublicUser.dart';
import 'package:provider/provider.dart';
import 'package:soundshare/models/Song.dart';
import 'package:soundshare/services/db.dart';
import 'package:soundshare/services/info-overlay.dart';
import 'package:soundshare/services/storage.dart';

class GroupPlayer extends StatefulWidget {
  final Function notifyParent;

  GroupPlayer({@required this.notifyParent});

  @override
  _GroupPlayerState createState() => _GroupPlayerState();
}

class _GroupPlayerState extends State<GroupPlayer> {
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Group group = Provider.of<Group>(context);

    return Scaffold(
      body: ListView.builder(
          itemCount: group.songs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                children: <Widget>[
                  Text("${group.songs[index].name}"),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.play_circle_outline),
                    onPressed: () => widget.notifyParent(group.songs[index].url, group.songs[index].name),
                  )
                ],
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: "Neue Gruppe erstellen",
          onPressed: () async {
            ProgressDialog dialog;
            try {
              File file = await FilePicker.getFile(type: FileType.AUDIO);

              String returnVal = await _displayDialog(context);
              String storagePath = "";
              if (returnVal == null || returnVal.isEmpty) {
                returnVal = path.basename(file.path);
                storagePath = returnVal.replaceAll(" ", "_");
              }

              dialog = InfoOverlay.showDynamicProgressDialog(context, "Lied wird hochgeladen..");

              /// Upload to firestore
              var task = storageService.upload(
                  file,
                  "groups/${group.id}/songs/$storagePath",
                  concatString: "");
              /// execute task to upload and display current progress
              task.events.listen((event) async {
                if (task.isInProgress) {
                  double percentage = (event.snapshot.bytesTransferred * 100 / event.snapshot.totalByteCount).roundToDouble();
                  dialog.update(progress: percentage, message: percentage / 2 > 50 ? "Fast fertig.." : null);
                }
              });
              /// wait for task to finish to proceed going back
              await task.onComplete;

              await databaseService.addSongToGroup(group, Song(name: returnVal, url: await task.lastSnapshot.ref.getDownloadURL()));

              dialog.dismiss();
            } catch (e) {
              print(e.toString());
              if (dialog != null) {
                dialog.dismiss();
              }
              InfoOverlay.showErrorSnackBar("Error uploading your file, please try again.");
            }
          }
      ),
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Namen für den Song"),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Namen des Songs angeben (optional)"),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Abbrechen'),
                textColor: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Hochladen'),
                onPressed: () {
                  Navigator.of(context).pop<String>(_textFieldController.value.text);
                },
              )
            ],
          );
        });
  }
}
