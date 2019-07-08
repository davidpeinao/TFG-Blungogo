import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:screen/screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geoloc;
import 'dart:async';

class TrackActivity extends StatefulWidget {
  @override
  _TrackActivityState createState() => _TrackActivityState();

  TrackActivity({Key key, this.id, this.name}) : super(key: key);
  final String id, name;
}

class _TrackActivityState extends State<TrackActivity> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Tracking activity"),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
              child: Text(
                '${widget.name}',
                style: new TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
              child: Text(
                '''Lat: ${instant["lat"]} - Long: ${instant["lon"]}
                  \nTimestamp: ${instant["timestamp"]}
                  \nSpeed: ${instant["speed"]}''',
                style: new TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            SpinKitWave(
              color: Colors.red,
              size: 50.0,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: RaisedButton(
                elevation: 10,
                padding: EdgeInsets.all(10),
                color: Colors.redAccent,
                onPressed: _endTrack,
                child: Text("End tracking"),
              ),
            )
          ]),
        ));
  }

  void _endTrack() {
    updateActivityData();
    Screen.keepOn(false);
    Navigator.pop(context);
  }

  //
  // LOCATION STUFF
  //

  LocationData _currentLocation;
  geoloc.Geolocator geolocator = geoloc.Geolocator();
  Map<String, String> instant = Map<String, String>();
  List<Map<String, String>> geoData = List<Map<String, String>>();

  //
  //Metrics
  //

  Future<Map<String, Object>> calculateMetrics() async {
    if (geoData.isNotEmpty) {
      double totalDistance = await calculateDistance();
      Duration totalTime = await calculateTotalTime();
      double averageSpeed =
          await calculateAverageSpeed(totalDistance, totalTime);
      // totalDistance IN METERS
      String strTotalDistance = totalDistance.toInt().toString();
      String strTotalTime = totalTime.toString().substring(0, 9);
      // averageSpeed IN KM/H
      String strAverageSpeed = averageSpeed.toStringAsFixed(2);
      print(
          "Dist: $strTotalDistance, Time: $strTotalTime, AvgSpeed: $strAverageSpeed.");

      var map = new Map<String, Object>();
      map['totalDistance'] = strTotalDistance;
      map['totalTime'] = strTotalTime;
      map['averageSpeed'] = strAverageSpeed;
      map['geoData'] = geoData;

      return map;
    } else {
      var map = new Map<String, Object>();
      map['totalDistance'] = "0";
      map['totalTime'] = "0";
      map['averageSpeed'] = "0";
      var defaultInstant = {
        "lat": "0.000",
        "long": "0.000",
        "timestamp": "0:00:00",
        "speed": "0.0"
      };
      var list = [defaultInstant, defaultInstant, defaultInstant];
      map['geoData'] = list;
    }
  }

  Future<double> calculateDistance() async {
    double totalDistance = 0.0;
    for (int i = 1; i < geoData.length; i++) {
      var start = geoData.elementAt(i - 1);
      var end = geoData.elementAt(i);

      totalDistance += await geolocator.distanceBetween(
          double.parse(start["lat"]),
          double.parse(start["lon"]),
          double.parse(end["lat"]),
          double.parse(end["lon"]));
    }
    print("Dist: $totalDistance");
    return totalDistance;
  }

  Future<dynamic> calculateTotalTime() async {
    String start = geoData.first["timestamp"];
    String end = geoData.last["timestamp"];
    DateTime startDate = DateTime.parse(start);
    DateTime endDate = DateTime.parse(end);

    Duration difference = endDate.difference(startDate);
    print("Diff:${difference.toString()}");

    return difference;
  }

  Future<double> calculateAverageSpeed(
      double totalDistance, Duration totalTime) async {
    double averageSpeed = 0.0;
    double totalKm = totalDistance / 1000;
    double timeInHours = (totalTime.inSeconds / 3600).toDouble();

    averageSpeed = totalKm / timeInHours;
    print("Speed:${averageSpeed.toString()}");
    return averageSpeed;
  }

  //
  //Metrics
  //

  void updateActivityData() async {
    DocumentReference documentReference =
        Firestore.instance.collection('activities').document(widget.id);
    final Map<String, dynamic> data = await calculateMetrics();
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(documentReference, data);
    });
    print('updating activity');
  }

  Map<String, String> toMap() {
    if (_currentLocation != null) {
      var map = new Map<String, String>();
      map['lat'] = _currentLocation.latitude.toString();
      map['lon'] = _currentLocation.longitude.toString();
      map['timestamp'] =
          DateTime.fromMillisecondsSinceEpoch(_currentLocation.time.toInt())
              .toString();
      map['speed'] = _currentLocation.speed.toString();
      instant = map;
      return map;
    }
    return Map<String, String>();
  }

  StreamSubscription<LocationData> _locationSubscription;
  Location _locationService = new Location();
  bool _permission = false;
  String error;

  initPlatformState() async {
    Screen.keepOn(true);
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;
                toMap();
                if (geoData != null) geoData.add(instant);
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }
  }

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }
}
