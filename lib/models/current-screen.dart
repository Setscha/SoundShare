import 'package:custom_navigator/custom_navigator.dart';
import 'package:flutter/material.dart';
import 'package:soundshare/models/User.dart';
import 'package:soundshare/services/db.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soundshare/widgets/group/group-view.dart';

import 'Group.dart';
import 'User.dart';

class ScreenModel extends Model {

  Widget _screen = FirstView();

  Widget get screen => _screen;

  void setScreen(Widget newScreen) {
    _screen = newScreen;

    notifyListeners();
  }

  static ScreenModel of(BuildContext context) => ScopedModel.of<ScreenModel>(context);
}

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return StreamProvider<List<Stream<Group>>>.value(
        value: databaseService.streamGroupsFromUser(user.uid),
        child: CustomNavigator(
          home: GroupView(),
          pageRoute: PageRoutes.materialPageRoute,
        )
    );
  }
}