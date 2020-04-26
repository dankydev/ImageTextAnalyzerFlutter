import 'package:flutter/material.dart';
import 'package:image_text_analyzer_flutter/home_page.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> _sleep(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sleep(1000).then((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = 125;

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/firebase.png",
              height: size,
              width: size,
            ),
            Image.asset(
              "assets/images/flutter.png",
              height: size,
              width: size,
            )
          ],
        ),
      ],
    ));
  }
}
