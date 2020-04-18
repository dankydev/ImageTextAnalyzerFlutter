import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_text_analyzer_flutter/image_processing/image_processing_page.dart';
import 'package:image_text_analyzer_flutter/text_processing/text_processing_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum TabItem { image, text }

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  CameraController _controller;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );
  }

  Future<CameraDescription> _initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    List<CameraDescription> _cameras = await availableCameras();
    CameraDescription _firstCamera = _cameras.first;

    return _firstCamera;
  }

  Widget _body() => SafeArea(
        child: Stack(
          children: <Widget>[
            CameraPreview(_controller),
            TabBarView(
              controller: _tabController,
              children: <Widget>[
                ImageProcessingPage(
                  cameraController: _controller,
                ),
                TextProcessingPage(
                  cameraController: _controller,
                )
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: _initCamera(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return CircularProgressIndicator();
          else {
            _controller = CameraController(
              snapshot.data,
              ResolutionPreset.max,
            );
            return FutureBuilder(
              future: _controller.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return CircularProgressIndicator();
                else
                  return _body();
              },
            );
          }
        },
      ),
    );
  }
}
