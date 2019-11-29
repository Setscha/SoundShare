import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:soundshare/main.dart';
import 'package:soundshare/models/Group.dart';
import 'package:soundshare/widgets/group/add-group.dart';
import 'package:soundshare/widgets/group/group-item.dart';
import 'package:provider/provider.dart';

class GroupView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Stream<Group>> groups = Provider.of<List<Stream<Group>>>(context);
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
      body: groups != null ? groups.length == 0 ? Center(child: Text("Keine Gruppen", style: Theme.of(context).textTheme.title,)) :
      ListView.separated(
        separatorBuilder: (ctx, i) => Divider(
          indent: 10,
          endIndent: 10,
          color: Colors.grey,
        ),
        itemCount: groups.length,
        itemBuilder: (BuildContext ctx, int index) =>
          StreamProvider<Group>.value(
            value: groups[index],
            child: GroupItem(index: index),
          )
      ) : SpinKitDoubleBounce(color: Colors.blueAccent),
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
