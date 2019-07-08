import 'package:blungogo/comparisons/make_graph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ComparisonView extends StatefulWidget {
  final FirebaseUser user;

  ComparisonView({this.data, this.user});
  Map<String, dynamic> data;

  _ComparisonViewState createState() => _ComparisonViewState();
}

class _ComparisonViewState extends State<ComparisonView> {
  String name;
  String description;

  buildData() {
    name = widget.data['name'] == null ? "" : widget.data['name'];
    description = widget.data['description'] == null
        ? "No description"
        : widget.data['description'];
  }

  deleteComparison() {
    Firestore.instance
        .collection("comparisons")
        .document(widget.data["id"])
        .delete();
    Navigator.pop(context);
  }

  Widget deleteButton() {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () => {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text(
                      "Are you sure you want to delete this comparison?"),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Yes"),
                      onPressed: () {
                        deleteComparison();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    buildData();
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Comparison"),
          actions: <Widget>[deleteButton()],
        ),
        body: Container(
          child: new ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 16.0),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 12.0),
                child: Text(
                  "Total distance:",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 16.0),
                  child: MakeGraph(
                      users: widget.data["users"],
                      startDate: widget.data["startDate"],
                      endDate: widget.data["endDate"],
                      metric: "totalDistance")),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 12.0),
                child: Text(
                  "Total time:",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 16.0),
                  child: MakeGraph(
                      users: widget.data["users"],
                      startDate: widget.data["startDate"],
                      endDate: widget.data["endDate"],
                      metric: "totalTime")),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 12.0),
                child: Text(
                  "Average speed:",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 16.0),
                  child: MakeGraph(
                      users: widget.data["users"],
                      startDate: widget.data["startDate"],
                      endDate: widget.data["endDate"],
                      metric: "averageSpeed")),
            ],
          ),
        ));
  }
}
