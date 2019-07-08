import 'package:blungogo/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blungogo/activities.dart' as activities;
import 'package:blungogo/comparisons.dart' as comparisons;
import 'package:blungogo/groups.dart' as groups;
import 'package:blungogo/user_settings.dart' as settings;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  const Home({Key key, this.user, this.auth, this.onSignOut}) : super(key: key);
  final FirebaseUser user;
  final BaseAuth auth;
  final VoidCallback onSignOut;
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _signOut() async {
      try {
        await widget.auth.signOut();
        widget.onSignOut();
      } catch (e) {
        print(e);
      }
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Blungogo"),
        backgroundColor: Colors.red,
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => settings.UserSettings(
                            user: widget.user,
                          )));
            },
            icon: Icon(Icons.settings),
          ),
          new IconButton(
              onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text("Are you sure you want to log out?"),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("Yes"),
                              onPressed: () {
                                _signOut();
                                Navigator.of(context).pop();
                              },
                            ),
                            new FlatButton(
                              child: new Text("No"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    )
                  },
              icon: Icon(Icons.exit_to_app)),
        ],
        bottom: new TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.flag)),
            new Tab(icon: new Icon(Icons.group)),
            new Tab(icon: new Icon(Icons.compare)),
          ],
        ),
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new activities.Activities(user: widget.user),
          new groups.Groups(user: widget.user),
          new comparisons.Comparisons(user: widget.user),
        ],
      ),
    );
  }
}
