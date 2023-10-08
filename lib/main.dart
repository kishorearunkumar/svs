import 'package:flutter/material.dart';
import 'package:svs/utils/routes.dart';
import 'package:svs/screens/layout/home_layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SVS',
      theme: ThemeData(
        primaryColor: new Color(0xffae275f),
        fontFamily: "Quicksand",
        primarySwatch: Colors.amber,
      ),
      routes: routes,
      home: HomeLayout(
        index: 2,
        filterIndex: 0,
      ),
    );
  }
}
