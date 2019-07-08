import 'package:blungogo/groups/groups_feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blungogo/groups/create_group.dart';

class Groups extends StatefulWidget {
  Groups({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('groups')
            .where('members', arrayContains: widget.user.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return GroupsFeed(
              documents: snapshot.data.documents, user: widget.user);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "Groups",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateGroup(user: widget.user)));
        },
        icon: Icon(Icons.add),
        label: Text("Add"),
      ),
    );
  }
}
