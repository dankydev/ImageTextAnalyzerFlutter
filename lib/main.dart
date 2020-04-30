import 'package:flutter/material.dart';
import 'package:image_text_analyzer_flutter/misc/no_glow_scroll_behavior.dart';
import 'package:image_text_analyzer_flutter/splash.dart';

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
      title: 'Image and Text analyzer',
      theme: ThemeData(
          brightness: Brightness.dark, indicatorColor: Colors.lightBlue),
      home: Scaffold(
        body: SplashPage(),
      ),
    );
  }
}
