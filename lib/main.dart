import 'package:flutter/material.dart';
import 'package:puv_tracker/pages/home_driver.dart';
import 'package:puv_tracker/pages/login.dart';

import './pages/login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'PUV Tracking';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp._title,
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/homedriver': (context) => HomeDriver(),
      },
    );
  }
}
