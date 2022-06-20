import 'package:flutter/material.dart';
import 'package:untitled/pages/home.dart';


void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'comfortaa'),
        initialRoute: '/home',
        routes: {
          '/home': (context) => Home(),
        }
    ),
  );
}