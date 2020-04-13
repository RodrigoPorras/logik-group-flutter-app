import 'package:flutter/material.dart';
import 'package:logik_groupv3/src/Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        body: Home(),
      ),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

    );
  }
}