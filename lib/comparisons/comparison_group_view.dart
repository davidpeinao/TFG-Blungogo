import 'package:blungogo/comparisons/choose_interval.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ComparisonGroupView extends StatefulWidget {
  final FirebaseUser user;
  String comparisonID;
  Map<String, dynamic> data;

  ComparisonGroupView({this.data, this.user, this.comparisonID});

  _ComparisonGroupViewState createState() => _ComparisonGroupViewState();
}

class _ComparisonGroupViewState extends State<ComparisonGroupView> {
  addUserToComparison(String name) {
    Firestore.instance
        .collection('comparisons')
        .document(widget.comparisonID)
        .get()
        .then((comparisonData) {
      List<dynamic> users = comparisonData["users"];
      var tempList = new List<dynamic>.from(users);
      if (!tempList.contains(name)) {
        tempList.add(name);
        Firestore.instance
            .collection('comparisons')
            .document(widget.comparisonID)
            .updateData({"users": tempList});
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Member $name added to comparison"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Got it!"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Pick a member:"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChooseInterval(comparisonID: widget.comparisonID))))
          ],
        ),
        body: ListView.builder(
          itemCount: widget.data["members"].length,
          itemBuilder: (BuildContext context, int index) {
            String name = widget.data["members"].elementAt(index);
            return Column(
              children: <Widget>[
                InkWell(
                    onTap: () => {addUserToComparison(name)},
                    child: Row(
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
                      ],
                    )),
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
