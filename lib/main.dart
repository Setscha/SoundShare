import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:soundshare/models/SoundShareColor.dart';
import 'package:soundshare/models/current-screen.dart';
import 'package:soundshare/services/auth.dart';
import 'package:soundshare/services/db.dart';
import 'package:soundshare/widgets/sidebar.dart';
import 'package:soundshare/widgets/authentication.dart';
import 'package:flutter/rendering.dart';
import 'models/User.dart';


void main() => runApp(MyApp());

final GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> authScaffoldKey = GlobalKey<ScaffoldState>();


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //debugPaintSizeEnabled = true;
    return ScopedModel<ScreenModel>(
      model: ScreenModel(),
      child: MultiProvider(
        providers: [
          StreamProvider<FirebaseUser>.value(value: authService.user),
        ],
        child: MaterialApp(
          title: "SoundShare",
          theme: ThemeData(
            primarySwatch: SoundShareColor.primary,
          ),
          home: Home()
        )
      )
    );
  }
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if (user != null) {
      return StreamProvider<User>.value(
        value: databaseService.streamProfile(user),
        child: Scaffold(
          key: mainScaffoldKey,
          body: Body(),
          drawer: Sidebar(),
        )
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        key: authScaffoldKey,
        body: AuthenticationPage()
      );
    }
  }
}

class Body extends StatefulWidget {
  createState() => _Body();
}

class _Body extends State<Body> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScreenModel>(
      builder: (context, child, model) => model.screen
    );
  }
}