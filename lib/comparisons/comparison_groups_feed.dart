import 'package:blungogo/comparisons/choose_interval.dart';
import 'package:blungogo/comparisons/comparison_group_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComparisonGroupsFeed extends StatelessWidget {
  final List<DocumentSnapshot> documents;
  final FirebaseUser user;
  String comparisonID;
  ComparisonGroupsFeed({this.documents, this.user, this.comparisonID});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Groups you are in"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChooseInterval(comparisonID: comparisonID))))
          ],
        ),
        body: ListView.builder(
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            String name = documents[index].data['name'] == null
                ? ""
                : documents[index].data['name'];

            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ComparisonGroupView(
                              data: documents[index].data,
                              user: user,
                              comparisonID: comparisonID))),
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
                                  fontSize: 22.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
