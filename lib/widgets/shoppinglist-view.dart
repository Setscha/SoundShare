import 'package:flutter/material.dart';
import 'package:soundshare/main.dart';
import 'package:soundshare/widgets/shopping-list.dart';

class ShoppingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text("Einkaufslisten"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Offen",),
              Tab(text: "Verlauf")
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            tooltip: "Open navigation menu",
            onPressed: () => mainScaffoldKey.currentState.openDrawer(),
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              children: <Widget>[
                ShoppingList(title: "Super liste", total: 18, bought: 4,),
                ShoppingList(title: "Schlechte liste", total: 4, bought: 3,),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
                ShoppingList(),
              ],
              //mainAxisAlignment: MainAxisAlignment.center,
            ),
            Text("VERLAUF DER EINKAUSLISTEN")
          ],
        ),
      )
    );
  }
}