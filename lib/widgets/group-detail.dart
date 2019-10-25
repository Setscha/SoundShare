import 'package:flutter/material.dart';
import 'package:soundshare/models/Group.dart';
import 'package:soundshare/services/db.dart';
import 'package:soundshare/widgets/group-userlist.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class GroupDetail extends StatefulWidget {
//  GroupDetail({
//    Key key,
//    this.group
//  }) : super(key: key);
//
//  final Group group;

  @override
  _GroupDetail createState() => _GroupDetail();
}

class _GroupDetail extends State<GroupDetail> {

  @override
  Widget build(BuildContext context) {
    Group group = Provider.of<Group>(context);
    return Provider<Group>.value(
        value: group,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Text(group.title),
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
                Text("Einkaufslisten der Gruppe"),
                Text("Statistiken der Gruppe"),
                GroupUserList()
              ],
            ),
          ),
        )
    );
  }
}