import 'package:flutter/material.dart';
import 'package:soundshare/models/User.dart';
import 'package:soundshare/widgets/settings/notificationsettings-view.dart';
import 'package:soundshare/services/auth.dart';
import 'package:soundshare/widgets/settings/privacypolicy-view.dart';
import 'package:soundshare/widgets/settings/profilesettings-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatelessWidget {
  String img = "https://www.indiewire.com/wp-content/uploads/2019/05/shutterstock_8999492b.jpg?w=780";


  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
              "Abmelden",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)
          ),
          content: Text("Möchten Sie sich von Ihrem soundshare-Konto abmelden?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                  "ABBRECHEN",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                  "OK",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
              ),
              onPressed: () {
                authService.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _showDialog(context);
              //Navigator.pop(context);
            },
          ),
        ],
      ),
      body:
      Test(),
    );
  }
}

class Test extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    User user  = Provider.of<User>(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Container(
            margin: EdgeInsets.only(bottom: 25.0),
            child:
            Hero(
              tag: "profilePicture",
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 50,
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child:
              Text(
                user.displayName,
                style: Theme.of(context).textTheme.headline,
                textAlign: TextAlign.center,
              )
          ),

          Text(
            user.email,
            //style: Theme.of(context).textTheme.headline,
            textAlign: TextAlign.center,
          ),


          Container(
              margin: const EdgeInsets.only(top: 30.0),
              child:
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[

                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Konto'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileSettingsView(),
                          )
                      )
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Benachrichtigungen'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationsSettingsView()
                          )
                      )
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.security),
                    title: Text('Datenschutz'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyPolicyView()
                          )
                      )
                    },
                  ),

                ],
              )
          ),


        ],
      ),
    );
  }



  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}