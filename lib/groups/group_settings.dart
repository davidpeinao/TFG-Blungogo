import 'package:blungogo/groups/add_users_group.dart';
import 'package:blungogo/groups/remove_users_group.dart';
import 'package:blungogo/groups/set_permissions_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupSettings extends StatelessWidget {
  GroupSettings({this.data});
  Map<String, dynamic> data;

  deleteGroup() {
    Firestore.instance.collection("groups").document(data["id"]).delete();
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Are you sure you want to delete the group?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                deleteGroup();
                Navigator.pop(context);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Settings of: ${data["name"]}"),
          actions: <Widget>[
            IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () => _showDialog(context),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: data["members"].length,
          itemBuilder: (BuildContext context, int index) {
            String name = data["members"].elementAt(index);
            String status = data["admins"].contains(name) ? "Admin" : "Member";
            final widgetItem = (index == 0)
                ? new Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.green.shade200,
                            elevation: 7,
                            child: Text("Add users"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddUsersGroup(
                                            data: data,
                                          )));
                            },
                          ),
                          RaisedButton(
                            color: Colors.red.shade200,
                            elevation: 7,
                            child: Text("Remove users"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RemoveUsersGroup(
                                            data: data,
                                          )));
                            },
                          ),
                          RaisedButton(
                            color: Colors.blue.shade200,
                            elevation: 7,
                            child: Text("Set permissions"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SetPermissionsGroup(
                                            data: data,
                                          )));
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 12.0, 12.0, 16.0),
                                child: Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 12.0, 12.0, 16.0),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        height: 2.0,
                        color: Colors.grey,
                      ),
                    ],
                  )
                : new Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 12.0, 12.0, 16.0),
                                child: Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 12.0, 12.0, 16.0),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        height: 2.0,
                        color: Colors.grey,
                      ),
                    ],
                  );
            return widgetItem;
          },
        ));
  }
}
