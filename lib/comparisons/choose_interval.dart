import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ChooseInterval extends StatefulWidget {
  ChooseInterval({Key key, this.comparisonID}) : super(key: key);
  String comparisonID;

  @override
  _ChooseIntervalState createState() => new _ChooseIntervalState();
}

class _ChooseIntervalState extends State<ChooseInterval> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _startDate = "Start date";
  String _endDate = "End date";

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Select time interval"),
      ),
      body: Form(
          key: _formKey,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                      onConfirm: (date) {
                    setState(() {
                      this._startDate = date.toString();
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Text(
                  '$_startDate',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                elevation: 10,
                color: Colors.blue.shade300,
              ),
              RaisedButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                      onConfirm: (date) {
                    setState(() {
                      this._endDate = date.toString();
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Text(
                  '$_endDate',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                elevation: 10,
                color: Colors.green.shade300,
              ),
              RaisedButton(
                onPressed: () => validate(),
                child: Text(
                  'Finish',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                color: Colors.red.shade400,
              ),
            ],
          ))),
    );
  }

  void validate() {
    if (_startDate != "Start date" && _endDate != "End date") {
      Firestore.instance
          .collection("comparisons")
          .document(widget.comparisonID)
          .updateData({"startDate": _startDate, "endDate": _endDate});
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Comparison created, you can go back to the feed"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Ok!"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
