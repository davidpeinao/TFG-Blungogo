import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blungogo/groups/group_settings.dart';

class GroupView extends StatefulWidget {
  final FirebaseUser user;

  GroupView({this.data, this.user});
  Map<String, dynamic> data;

  _GroupViewState createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  Widget createIcon() {
    final widgetItem = (widget.data["admins"].contains(widget.user.email))
        ? new IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupSettings(
                            data: widget.data,
                          )));
            },
          )
        : new IconButton(
            icon: new Icon(Icons.not_interested), onPressed: () => {});

    return widgetItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Group: ${widget.data["name"]}"),
          actions: <Widget>[createIcon()],
        ),
        body: ListView.builder(
          itemCount: widget.data["members"].length,
          itemBuilder: (BuildContext context, int index) {
            String name = widget.data["members"].elementAt(index);
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 16.0),
                          child: Text(
                            name,
                            style: TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 2.0,
                  color: Colors.grey,
                )
              ],
            );
          },
        ));
  }
}
