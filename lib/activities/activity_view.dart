import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/polyline.dart';

// place your Maps API Key here
var myKey = "";

class ActivityView extends StatefulWidget {
  ActivityView({Key key, this.data}) : super(key: key);
  final Map<String, dynamic> data;

  _ActivityViewState createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  String name;
  String description;
  String datetime;
  String totalDistance;
  String totalTime;
  String averageSpeed;
  List<dynamic> geoData;
  MapView mapView;

  buildData() {
    name = widget.data['name'] == null ? "" : widget.data['name'];
    description =
        widget.data['description'] == null ? "" : widget.data['description'];
    datetime = widget.data['datetime'] == null ? "" : widget.data['datetime'];
    totalDistance = widget.data['totalDistance'] == null
        ? ""
        : widget.data['totalDistance'];
    totalTime =
        widget.data['totalTime'] == null ? "" : widget.data['totalTime'];
    averageSpeed =
        widget.data['averageSpeed'] == null ? "" : widget.data['averageSpeed'];
    geoData = widget.data['geoData'];
  }

  @override
  Widget build(BuildContext context) {
    buildData();
    MapView.setApiKey(myKey);
    mapView = MapView();
    CameraPosition cameraPosition;
    var staticMapProvider = new StaticMapProvider(myKey);
    Uri staticMapUri;

    List<Polyline> _lines = List<Polyline>();
    for (var i = 1; i < geoData.length - 1; i++) {
      Location start = Location(double.parse(geoData.elementAt(i - 1)["lat"]),
          double.parse(geoData.elementAt(i - 1)["lon"]));
      Location end = Location(double.parse(geoData.elementAt(i)["lat"]),
          double.parse(geoData.elementAt(i)["lon"]));
      List<Location> line = List<Location>();
      line.add(start);
      line.add(end);
      Polyline polyline = Polyline(i.toString(), line);
      _lines.add(polyline);
    }
    mapView.setPolylines(_lines);

    @override
    initState() {
      super.initState();
      cameraPosition = new CameraPosition(Locations.portland, 2.0);
    }

    _handleDismiss() async {
      double zoomLevel = await mapView.zoomLevel;
      Location centerLocation = await mapView.centerLocation;
      List<Polyline> visibleLines = await mapView.visiblePolyLines;

      var uri = await staticMapProvider.getImageUriFromMap(mapView,
          width: 900, height: 400);
      setState(() => staticMapUri = uri);
      mapView.dismiss();
    }

    showMap() {
      mapView.show(
          new MapOptions(
              mapViewType: MapViewType.normal,
              showUserLocation: true,
              showMyLocationButton: true,
              showCompassButton: true,
              initialCameraPosition: new CameraPosition(
                  new Location(_lines.first.points.first.latitude,
                      _lines.first.points.first.longitude),
                  15.0),
              hideToolbar: false,
              title: "Your path"),
          toolbarActions: [new ToolbarAction("Close", 1)]);
      StreamSubscription sub = mapView.onMapReady.listen((_) {
        mapView.setPolylines(_lines);
        mapView.onToolbarAction.listen((id) {
          _handleDismiss();
        });
      });
    }

    deleteActivity() {
      Firestore.instance
          .collection("activities")
          .document(widget.data["id"])
          .delete();
      Navigator.pop(context);
    }

    void _showDialog(context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Are you sure you want to delete this activity?"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  deleteActivity();
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
      );
    }

    return Scaffold(
        appBar: new AppBar(
          title: new Text("Activity: $name"),
          actions: <Widget>[
            FlatButton(
              child: new Text('Delete',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text(
                              "Are you sure you want to delete this activity?"),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("Yes"),
                              onPressed: () {
                                deleteActivity();
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
            )
          ],
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
                padding: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 12.0),
                child: Text(
                  "Date:",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      background: Paint()..color = Colors.red.shade50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                child: Text(
                  datetime,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 12.0),
                child: Text(
                  "Distance:",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      background: Paint()..color = Colors.blue.shade50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                child: Text(
                  totalDistance + "meters",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 12.0),
                child: Text(
                  "Duration:",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      background: Paint()..color = Colors.green.shade50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                child: Text(
                  totalTime,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 12.0),
                child: Text(
                  "Avg. speed:",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      background: Paint()..color = Colors.yellow.shade50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                child: Text(
                  averageSpeed + "km/h",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Container(
                height: 200.0,
                child: new Stack(
                  children: <Widget>[
                    new Center(
                        child: new Container(
                      child: new Text(
                        "View your route",
                        style:
                            TextStyle(fontSize: 30, color: Colors.red.shade300),
                        textAlign: TextAlign.center,
                      ),
                      padding: const EdgeInsets.all(20.0),
                    )),
                    new InkWell(
                      child: new Center(
                        child: new Image.network(staticMapUri.toString()),
                      ),
                      onTap: showMap,
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
