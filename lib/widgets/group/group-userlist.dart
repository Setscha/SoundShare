import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:soundshare/models/Group.dart';
import 'package:soundshare/models/PublicUser.dart';
import 'package:provider/provider.dart';


class GroupUserList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Group group = Provider.of<Group>(context);

    List<PublicUser> membersInGroup = List.from(group.members);
    membersInGroup.removeWhere((member) => member.uid == group.creator.uid ||
        member.displayName.toLowerCase().contains("kek"));
    List<Widget> members = membersInGroup.map((member) {
      return ListTile(
        onLongPress: () {print(member.displayName);},
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              CircleAvatar(backgroundImage: NetworkImage(member.photoUrl)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    member.displayName,
                    style: Theme.of(context).textTheme.subhead,
                    overflow: TextOverflow.ellipsis
                  ),
                )
              ),
            ],
          )
        ),
      );
    }).toList();

    members.insert(0, ListTile(
      title: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            CircleAvatar(backgroundImage: NetworkImage(group.creator.photoUrl)),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  group.creator.displayName,
                  style: Theme.of(context).textTheme.subhead,
                  overflow: TextOverflow.ellipsis
                ),
              )
            ),
            Text("Gruppenersteller", style: TextStyle(color: Colors.green))
          ],
        )
      ),
    ));


    final DateTime dateTime = group.created.toDate();
    return ListView(
      children: <Widget>[
        Padding(
          child: Text("Erstellt am: ${dateTime.day}.${dateTime.month}.${dateTime.year}",
            style: Theme.of(context).textTheme.subhead,),
          padding: EdgeInsets.all(10),
        ),
        Column(
          children: members,
        )
      ],
    );
  }
}


/*
ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
          endIndent: 10,
          indent: 10,
        ),
        itemCount: members.length,
        itemBuilder: (context, index) => members[index]
    );
 */