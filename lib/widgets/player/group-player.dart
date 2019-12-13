import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:soundshare/models/Group.dart';
import 'package:soundshare/models/PublicUser.dart';
import 'package:provider/provider.dart';
import 'package:soundshare/models/Song.dart';


class GroupPlayer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Song> songs = Provider.of<Group>(context).songs;

    return Scaffold(
      body: songs.length > 0 ? ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                children: <Widget>[
                  Text("${songs[index].name}"),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.play_circle_outline),
                    onPressed: () {},
                  )
                ],
              ),
            );
          }
      ) : Center(child: Text("Noch keine Songs")),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: "Neue Gruppe erstellen",
          onPressed: () => {}
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
                icon: Icon(Icons.play_circle_outline),
                onPressed: () {},
              )
            ]
        ),
      )
    );
  }
}