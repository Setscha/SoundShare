import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:soundshare/models/Song.dart';

class PlayerHistory extends StatelessWidget {

  List<Song> songs = [
    Song(id: "KWEIh23K", songurl: "http://test.com", title: "Dubstep"),
    Song(id: "IJO343JN3mj", songurl: "http://test.com", title: "Rofl"),
    Song(id: "Kso38Jnuf23D", songurl: "http://test.com", title: "Kek"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }
}
