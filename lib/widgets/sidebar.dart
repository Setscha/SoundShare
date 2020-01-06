import 'package:custom_navigator/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundshare/models/Group.dart';
import 'package:soundshare/models/User.dart';
import 'package:soundshare/models/current-screen.dart';
import 'package:soundshare/services/auth.dart';
import 'package:soundshare/services/db.dart';
import 'package:soundshare/widgets/invites/invite-view.dart';
import 'package:soundshare/widgets/settings/settings-view.dart';

import 'group/group-view.dart';


class Sidebar extends StatefulWidget {
  @override
  _Sidebar createState() => _Sidebar();
}
class _Sidebar extends State<Sidebar> {
  String img = "https://cdn3.iconfinder.com/data/icons/essentials-vol-1-1/512/Headphones-512.png";

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
           ),
            accountName: Text(user.displayName),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl != '' ? user.photoUrl : img),
            ),
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text("Gruppen"),
            onTap: () {
              ScreenModel.of(context).setScreen(StreamProvider<List<Group>>.value(
                  value: databaseService.streamGroupsFromUser(user.uid),
                  child: CustomNavigator(
                    home: GroupView(),
                    pageRoute: PageRoutes.materialPageRoute,
                  )
              ));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text("Einladungen"),
            onTap: () {
              ScreenModel.of(context).setScreen(InviteView());
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Einstellungen"),
            onTap: () {
//              ScreenModel.of(context).setScreen(SettingsView());
//              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsView()));
            },
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.arrow_back),
            title: Text("Logout"),
            onTap: () {
              authService.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      )
    );
  }
}