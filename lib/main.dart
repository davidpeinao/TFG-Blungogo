import 'package:blungogo/root_page.dart';
import 'package:blungogo/auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blungogo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: RootPage(auth: new Auth()),
    );
  }
}
