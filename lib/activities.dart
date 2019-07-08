import 'package:blungogo/activities/activity_feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blungogo/activities/create_activity.dart';

class Activities extends StatefulWidget {
  Activities({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('activities')
            .where('email', isEqualTo: widget.user.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ActivityFeed(documents: snapshot.data.documents);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "Activities",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateActivity(user: widget.user)));
        },
        icon: Icon(Icons.add),
        label: Text("Add"),
      ),
    );
  }
}
