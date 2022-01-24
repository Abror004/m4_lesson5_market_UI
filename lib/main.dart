import 'package:flutter/material.dart';
import 'package:m4_lesson5/home_Page.dart';
import 'package:m4_lesson5/recomendation_Page.dart';
import 'package:m4_lesson5/test_Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home_Page(),
      routes: {
        Home_Page.id: (context) => Home_Page(),
        Recomendation_Page.id: (context) => Recomendation_Page(),
        Test_Page.id: (context) => Test_Page(),
      },
    );
  }
}
