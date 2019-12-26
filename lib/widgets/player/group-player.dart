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

class GroupPlayer extends StatelessWidget {
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
                    onPressed: () {},
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
              if (returnVal == null) returnVal = path.basename(file.path).replaceAll(" ", "_");

              dialog = InfoOverlay.showDynamicProgressDialog(context, "Lied wird hochgeladen..");

              /// Upload to firestore
              var task = storageService.upload(
                  file,
                  "groups/${group.id}/songs/$returnVal",
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

              databaseService.addSongToGroup(group, Song(name: returnVal, url: await task.lastSnapshot.ref.getDownloadURL()));
              await task.events.last;
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
