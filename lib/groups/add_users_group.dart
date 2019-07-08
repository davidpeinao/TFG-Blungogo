import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUsersGroup extends StatefulWidget {
  AddUsersGroup({Key key, this.data}) : super(key: key);
  Map<String, dynamic> data;
  @override
  _AddUsersGroupState createState() => new _AddUsersGroupState();
}

class _AddUsersGroupState extends State<AddUsersGroup> {
  final TextEditingController _newMember = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add members to ${widget.data["name"]}"),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
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
                    if (_newMember.text.trim() != "") {
                      List<dynamic> members = widget.data["members"];
                      var tempList = new List<dynamic>.from(members);
                      tempList.add(_newMember.text.trim());
                      Firestore.instance
                          .collection('groups')
                          .document(widget.data["id"])
                          .updateData({"members": tempList});
                      _newMember.clear();
                    }
                  })),
        ),
      ),
    );
  }
}
