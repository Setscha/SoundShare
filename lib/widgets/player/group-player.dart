import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:soundshare/models/Group.dart';
import 'package:soundshare/models/PublicUser.dart';
import 'package:provider/provider.dart';
import 'package:soundshare/models/Song.dart';


class GroupPlayer extends StatelessWidget {

  List<Song> songs = [
    Song(id: "KWEIh23K", songurl: "http://test.com", title: "Dubstep"),
    Song(id: "IJO343JN3mj", songurl: "http://test.com", title: "Rofl"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                children: <Widget>[
                  Text("${songs[index].title}"),
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