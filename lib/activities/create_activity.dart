import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:blungogo/activities/track_activity.dart';

class CreateActivity extends StatefulWidget {
  CreateActivity({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _CreateActivityState createState() => new _CreateActivityState();
}

class _CreateActivityState extends State<CreateActivity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name, _description, _id;
  String _datetime = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Create Activity"),
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
              FlatButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true, onConfirm: (date) {
                      this._datetime = date.toString();
                      print('date chosen: $_datetime');
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    'Select date and time',
                    style: TextStyle(color: Colors.blue),
                  )),
              RaisedButton(
                onPressed: startActivity,
                child: Text('Start'),
              ),
            ],
          )),
    );
  }

  void startActivity() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      createActivityData(_name, _description, _datetime, widget.user.email);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TrackActivity(
                    id: _id,
                    name: _name,
                  )));
    }
  }

  createActivityData(
      String name, String description, String datetime, String email) async {
    DocumentReference dr =
        Firestore.instance.collection('activities').document();
    _id = dr.documentID;
    final ActivityData activitydata =
        ActivityData(dr.documentID, name, description, datetime, email);
    final Map<String, dynamic> data = activitydata.toMap();

    Firestore.instance
        .collection('activities')
        .document(dr.documentID)
        .setData(data);

    print('creating activity');
  }
}

///
///
///
///
///
///

class ActivityData {
  String _id;
  String _name;
  String _description;
  String _datetime;
  String _email;

  ActivityData(
      this._id, this._name, this._description, this._datetime, this._email);

  ActivityData.map(dynamic obj) {
    this._id = obj['id'];
    this._name = obj['name'];
    this._description = obj['description'];
    this._datetime = obj['datetime'];
    this._email = obj['email'];
  }

  String get id => _id;
  String get title => _name;
  String get description => _description;
  String get datetime => _datetime;
  String get email => _email;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['description'] = _description;
    map['datetime'] = _datetime;
    map['email'] = _email;

    return map;
  }

  ActivityData.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._description = map['description'];
    this._datetime = map['datetime'];
    this._email = map['email'];
  }
}
