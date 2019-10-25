import 'package:flutter/material.dart';
import 'package:soundshare/main.dart';
import 'package:soundshare/models/Group.dart';
import 'package:soundshare/models/User.dart';
import 'package:soundshare/services/db.dart';
import 'package:soundshare/widgets/add-group.dart';
import 'package:soundshare/widgets/group-item.dart';
import 'package:provider/provider.dart';

class GroupView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Gruppen"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          tooltip: "Open navigation menu",
          onPressed: () => mainScaffoldKey.currentState.openDrawer(),
        ),
      ),
      body: StreamProvider<List<Group>>.value(
          value: databaseService.streamGroupsFromUser(user.uid),
          child: ListView(
            children: <Widget>[
              GroupItem(),
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: "Neue Gruppe erstellen",
          onPressed: () =>
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddGroup()),
              )
      ),
    );
  }
}
