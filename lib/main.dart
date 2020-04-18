import 'package:flutter/material.dart';
import 'package:sac_pw2_vision/home_page.dart';
import 'package:sac_pw2_vision/misc/no_glow_scroll_behavior.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: child,
        );
      },
      title: 'SACTextAndImageAnalyzer',
      theme: ThemeData(
          brightness: Brightness.dark, indicatorColor: Colors.lightBlue),
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}
