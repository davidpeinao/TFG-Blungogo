import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoveUsersGroup extends StatefulWidget {
  RemoveUsersGroup({Key key, this.data}) : super(key: key);
  Map<String, dynamic> data;
  @override
  _RemoveUsersGroupState createState() => new _RemoveUsersGroupState();
}

class _RemoveUsersGroupState extends State<RemoveUsersGroup> {
  final TextEditingController _newMember = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Remove members from ${widget.data["name"]}"),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: TextFormField(
          controller: _newMember,
          decoration: InputDecoration(
              hintText: 'Remove Member',
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
                      if (members.contains(_newMember.text.trim())) {
                        tempList.remove(_newMember.text.trim());
                        Firestore.instance
                            .collection('groups')
                            .document(widget.data["id"])
                            .updateData({"members": tempList});
                        _newMember.clear();
                      }
                    }
                  })),
        ),
      ),
    );
  }
}
