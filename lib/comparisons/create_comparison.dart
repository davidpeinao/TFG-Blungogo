import 'package:blungogo/comparisons/comparison_groups_feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateComparison extends StatefulWidget {
  CreateComparison({Key key, this.user, this.documents}) : super(key: key);
  final FirebaseUser user;
  final List<DocumentSnapshot> documents;

  @override
  _CreateComparisonState createState() => new _CreateComparisonState();
}

class _CreateComparisonState extends State<CreateComparison> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name, _description, _id;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Create Comparison"),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Enter a name ';
                  }
                },
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (input) => _name = input,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (input) => _description = input,
              ),
              RaisedButton(
                onPressed: startComparison,
                child: Text('Start'),
              ),
            ],
          )),
    );
  }

  void startComparison() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      createComparisonData(_name, _description, widget.user.email);
      getUserGroups(widget.user.email);
    }
  }

  createComparisonData(String name, String description, String email) async {
    DocumentReference dr =
        Firestore.instance.collection('comparisons').document();
    _id = dr.documentID;
    final ComparisonData Comparisondata =
        ComparisonData(dr.documentID, name, description, email);
    final Map<String, dynamic> data = Comparisondata.toMap();

    Firestore.instance
        .collection('comparisons')
        .document(dr.documentID)
        .setData(data);

    print('creating Comparison');
  }

  getUserGroups(String userEmail) {
    Firestore.instance
        .collection('groups')
        .where('members', arrayContains: widget.user.email)
        .getDocuments()
        .then((data) {
      goToGroupsFeed(data);
    });
  }

  goToGroupsFeed(QuerySnapshot data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ComparisonGroupsFeed(
                  documents: data.documents,
                  user: widget.user,
                  comparisonID: _id,
                )));
  }
}

///
///
///
///
///
///

class ComparisonData {
  String _id;
  String _name;
  String _description;
  String _creator;

  ComparisonData(this._id, this._name, this._description, this._creator);

  ComparisonData.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._description = obj['description'];
    this._creator = obj['creator'];
  }

  String get id => _id;
  String get title => _name;
  String get description => _description;
  String get creator => _creator;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['description'] = _description;
    map['creator'] = _creator;
    map['users'] = List();

    return map;
  }

  ComparisonData.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._description = map['description'];
    this._creator = map['creator'];
  }
}
