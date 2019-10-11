import 'package:flutter/material.dart';
import 'package:soundshare/main.dart';

import 'invite.dart';

class GroupInviteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Einladungen"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          tooltip: "Open navigation menu",
          onPressed: () => mainScaffoldKey.currentState.openDrawer(),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Invite(title: "Keko Gruppe"),
          Invite(),
        ],
      ),
    );
  }
}
