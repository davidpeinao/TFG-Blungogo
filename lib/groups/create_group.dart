import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateGroup extends StatefulWidget {
  CreateGroup({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _CreateGroupState createState() => new _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  List<String> _members = List<String>();
  final TextEditingController _newMember = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Create Group"),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Enter a name ';
                    }
                  },
                  decoration: InputDecoration(labelText: 'Group name'),
                  onSaved: (input) => _name = input,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16.0),
                child: TextFormField(
                  controller: _newMember,
                  decoration: InputDecoration(
                      hintText: 'Add Member',
                      filled: true,
                      prefixIcon: Icon(
                        Icons.person_add,
                        size: 28.0,
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            if (_newMember.text.trim() != "")
                              _members.add(_newMember.text.trim());
                            _newMember.clear();
                            print("${_members.toString()}");
                          })),
                ),
              ),
              RaisedButton(
                onPressed: createGroup,
                child: Text('Create'),
              ),
            ],
          )),
    );
  }

  createGroup() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _members.add(widget.user.email);

      DocumentReference dr =
          Firestore.instance.collection('activities').document();

      List<dynamic> admins = [widget.user.email];
      Map<String, Object> data = new Map<String, Object>();
      data['name'] = _name;
      data['members'] = _members;
      data['admins'] = admins;
      data["id"] = dr.documentID;

      Firestore.instance
          .collection('groups')
          .document(dr.documentID)
          .setData(data);

      print('creating group');
      print("${data.toString()}");
      Navigator.pop(context);

      return data;
    }
  }
}
