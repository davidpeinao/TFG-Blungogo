import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blungogo/comparisons/graph.dart';

class MakeGraph extends StatefulWidget {
  MakeGraph({Key key, this.users, this.startDate, this.endDate, this.metric})
      : super(key: key);
  final List<dynamic> users;
  final String startDate;
  final String endDate;
  final String metric;
  // map that contains the user name and list with all his activities
  Map<String, List<Map<String, dynamic>>> allActivities = Map();

  _MakeGraphState createState() => _MakeGraphState();
}

class _MakeGraphState extends State<MakeGraph> {
  getUserActivities() {
    DateTime startDateTime = DateTime.parse(widget.startDate);
    DateTime endDateTime = DateTime.parse(widget.endDate);

    for (dynamic user in widget.users) {
      Firestore.instance
          .collection("activities")
          .where("email", isEqualTo: user)
          .getDocuments()
          .then((activities) {
        // list with all the activities of a user
        List<Map<String, dynamic>> userActivities = List();

        for (var activity in activities.documents) {
          DateTime activityDateTime = DateTime.parse(activity.data["datetime"]);
          // if datetime is between startDate and endDate, activity is selected
          if (activityDateTime.isAfter(startDateTime) &&
              activityDateTime.isBefore(endDateTime)) {
            activity.data.remove("description");
            activity.data.remove("email");
            activity.data.remove("geoData");
            activity.data.remove("id");
            activity.data.remove("name");
            activity.data.remove("datetime");
            activity.data["datetime"] = activityDateTime;

            userActivities.add(activity.data);
          }
        }

        setState(() {
          widget.allActivities[user] = userActivities;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getUserActivities();
    return SafeArea(
        child: Column(children: [
      Container(
        child: Graph.withSampleData(widget.allActivities, widget.metric),
        height: 250,
      )
    ]));
  }
}
