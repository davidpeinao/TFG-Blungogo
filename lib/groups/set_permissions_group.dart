import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SetPermissionsGroup extends StatefulWidget {
  SetPermissionsGroup({Key key, this.data}) : super(key: key);
  Map<String, dynamic> data;

  _SetPermissionsGroupState createState() => _SetPermissionsGroupState();
}

class _SetPermissionsGroupState extends State<SetPermissionsGroup> {
  checkStatus(String status, String name) {
    if (status == "Member") {
      final DocumentReference reference =
          Firestore.instance.collection("groups").document(widget.data["id"]);
      Firestore.instance.runTransaction((transaction) async {
        final freshSnapshot = await transaction.get(reference);
        List<dynamic> admins = freshSnapshot.data["admins"];
        var tempList = new List<dynamic>.from(admins);
        tempList.add(name);

        await transaction.update(reference, {'admins': tempList});
      });
    }
    if (status == "Admin") {
      final DocumentReference reference =
          Firestore.instance.collection("groups").document(widget.data["id"]);
      Firestore.instance.runTransaction((transaction) async {
        final freshSnapshot = await transaction.get(reference);
        List<dynamic> admins = freshSnapshot.data["admins"];
        var tempList = new List<dynamic>.from(admins);
        tempList.remove(name);

        await transaction.update(reference, {'admins': tempList});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Tap to change status"),
        ),
        body: ListView.builder(
          itemCount: widget.data["members"].length,
          itemBuilder: (BuildContext context, int index) {
            String name = widget.data["members"].elementAt(index);
            String status =
                widget.data["admins"].contains(name) ? "Admin" : "Member";
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      checkStatus(status, name);
                      status = status == "Member" ? "Admin" : "Member";
                    });
                  },
                  child: new Column(
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
                  ),
                );
              },
            );
          },
        ));
  }
}
