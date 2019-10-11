import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soundshare/widgets/groupinvite-view.dart';

class ScreenModel extends Model {
  Widget _screen = GroupInviteView();

  Widget get screen => _screen;

  String _title = "Einladungen";

  String get title => _title;

  void setScreen(Widget newScreen, String title) {
    _screen = newScreen;
    _title = title;

    notifyListeners();
  }

  static ScreenModel of(BuildContext context) => ScopedModel.of<ScreenModel>(context);
}