import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sac_pw2_vision/image_processing/image_classifying_page.dart';
import 'package:sac_pw2_vision/shared/stack_switch_element.dart';

class ImageProcessingPage extends StatefulWidget {
  final CameraController cameraController;

  ImageProcessingPage({Key key, @required this.cameraController})
      : super(key: key);

  @override
  _ImageProcessingPageState createState() => _ImageProcessingPageState();
}

class _ImageProcessingPageState extends State<ImageProcessingPage> {
  bool _imageIsOnCloud;

  @override
  void initState() {
    _imageIsOnCloud = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          StackSwitchElement(
            title: "Cloud",
            switchActivated: _imageIsOnCloud,
            onSwitchChanged: (actived) {
              setState(() {
                _imageIsOnCloud = actived;
              });
            },
            top: 20,
            right: 20,
            activeColor: Colors.lightBlue,
            size: Size(110, 0),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              tooltip: "Analyze image",
              backgroundColor: Colors.lightBlue,
              child: Icon(Icons.image),
              onPressed: () async {
                try {
                  final path = join(
                    (await getTemporaryDirectory()).path,
                    '${DateTime.now()}.png',
                  );

                  await widget.cameraController.takePicture(path);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageClassifyingPage(
                        imageLabeler: _imageIsOnCloud
                            ? FirebaseVision.instance.cloudImageLabeler()
                            : FirebaseVision.instance.imageLabeler(),
                        imagePath: path,
                      ),
                    ),
                  );
                } catch (e) {
                  print(e);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
