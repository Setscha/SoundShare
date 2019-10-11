import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class Invite extends StatelessWidget {
  final String title;
  Invite({this.title = "Gruppe #1"});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.title),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {},
                  color: Colors.green,
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {},
                  color: Colors.red,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}