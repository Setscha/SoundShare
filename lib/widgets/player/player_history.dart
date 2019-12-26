import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:soundshare/models/Group.dart';

class PlayerHistory extends StatefulWidget {
  final Function notifyParent;

  PlayerHistory({@required this.notifyParent});


  @override
  _PlayerHistoryState createState() => _PlayerHistoryState();
}

class _PlayerHistoryState extends State<PlayerHistory> {
  @override
  Widget build(BuildContext context) {
    List<String> songs = Provider.of<Group>(context).history;
    return songs.length > 0 ? ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Row(
            children: <Widget>[
              Text("${songs[index]}")
            ],
          ),
        );
      }
    ) : Center(child: Text("Keine Songs im Verlauf"));
  }
}
