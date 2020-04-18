import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_text_analyzer_flutter/shared/stack_switch_element.dart';
import 'package:image_text_analyzer_flutter/text_processing/text_in_picture_recognizer_widget.dart';

class TextProcessingPage extends StatefulWidget {
  final CameraController cameraController;

  TextProcessingPage({Key key, @required this.cameraController})
      : super(key: key);

  @override
  _TextProcessingPageState createState() => _TextProcessingPageState();
}

class _TextProcessingPageState extends State<TextProcessingPage> {
  bool _textIsOnCloud;
  bool _showBlocks;
  bool _showLines;
  bool _showElements;

  @override
  void initState() {
    _textIsOnCloud = false;
    _showBlocks = false;
    _showLines = false;
    _showElements = true;
    super.initState();
  }

  Widget floatingButton(context) {
    return Positioned(
      bottom: 30,
      right: 30,
      child: FloatingActionButton(
        tooltip: "Analyze text in image",
        backgroundColor: Colors.lightBlue,
        child: Icon(
          Icons.text_format,
          size: 30,
        ),
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
                builder: (context) => TextInPictureRecognizerWidget(
                  showBlocks: _showBlocks,
                  showLines: _showLines,
                  showElements: _showElements,
                  imagePath: path,
                  textRecognizer: _textIsOnCloud
                      ? FirebaseVision.instance.cloudTextRecognizer()
                      : FirebaseVision.instance.textRecognizer(),
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }

  Widget _textProcessingPage(context) {
    double _fromTop = 40;
    double _distance = 48;
    double _fromRight = 20;
    double _fromCloud = 0;

    return Stack(
      children: <Widget>[
        StackSwitchElement(
          title: "Cloud",
          switchActivated: _textIsOnCloud,
          onSwitchChanged: (actived) {
            setState(() {
              _textIsOnCloud = actived;
            });
          },
          top: _fromTop,
          right: _fromRight,
          activeColor: Colors.lightBlue,
          size: Size(135, 0),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        StackSwitchElement(
          title: "Blocks",
          switchActivated: _showBlocks,
          onSwitchChanged: (actived) {
            setState(() {
              _showBlocks = actived;
            });
          },
          top: _fromTop + _distance + _fromCloud,
          right: _fromRight,
          activeColor: Colors.red,
          size: Size(135, 0),
        ),
        StackSwitchElement(
          title: "Lines",
          switchActivated: _showLines,
          onSwitchChanged: (actived) {
            setState(() {
              _showLines = actived;
            });
          },
          top: _fromTop + _distance * 2 + _fromCloud,
          right: _fromRight,
          activeColor: Colors.yellow,
          size: Size(135, 0),
        ),
        StackSwitchElement(
          title: "Elements",
          switchActivated: _showElements,
          onSwitchChanged: (actived) {
            setState(() {
              _showElements = actived;
            });
          },
          top: _fromTop + _distance * 3 + _fromCloud,
          right: _fromRight,
          activeColor: Colors.green,
          size: Size(135, 0),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        ),
        floatingButton(context)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _textProcessingPage(context);
  }
}
