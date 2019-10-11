import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundshare/models/User.dart';
import 'package:soundshare/models/current-screen.dart';
import 'package:soundshare/services/auth.dart';
import 'package:soundshare/widgets/groupinvite-view.dart';


class Sidebar extends StatefulWidget {
  @override
  _Sidebar createState() => _Sidebar();
}
class _Sidebar extends State<Sidebar> {
  String img = "https://proxy.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.tractionwise.com%2Fwp-content%2Fuploads%2F2016%2F04%2FIcon-Person.png&f=1&nofb=1";

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
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text("Einladungen"),
            onTap: () {
              ScreenModel.of(context).setScreen(GroupInviteView(), "Einladungen");
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Einstellungen"),
            onTap: () {
              Navigator.pop(context);
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