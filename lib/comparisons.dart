import 'package:blungogo/comparisons/comparison_feed.dart';
import 'package:blungogo/comparisons/create_comparison.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comparisons extends StatefulWidget {
  Comparisons({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  _ComparisonsState createState() => _ComparisonsState();
}

class _ComparisonsState extends State<Comparisons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('comparisons')
            .where('creator', isEqualTo: widget.user.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ComparisonsFeed(documents: snapshot.data.documents);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "Comparisons",
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateComparison(user: widget.user)));
        },
        icon: Icon(Icons.add),
        label: Text("Add"),
      ),
    );
  }
}
