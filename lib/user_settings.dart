import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSettings extends StatefulWidget {
  UserSettings({Key key, this.user}) : super(key: key);
  FirebaseUser user;
  @override
  _UserSettingsState createState() => new _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final TextEditingController _newNickName = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Change your nickname"),
      ),
      body: Container(
          margin: EdgeInsets.all(16.0),
          child: TextFormField(
              controller: _newNickName,
              decoration: InputDecoration(
                  hintText: 'Enter your new nick',
                  filled: true,
                  prefixIcon: Icon(
                    Icons.add_box,
                    size: 28.0,
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_newNickName.text.trim() != "") {
                          Firestore.instance
                              .collection('users')
                              .document(widget.user.uid)
                              .updateData({"nick": _newNickName.text});

                          Navigator.pop(context);
                        }
                      })))),
    );
  }
}
