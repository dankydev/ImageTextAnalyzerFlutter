import 'dart:async';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_text_analyzer_flutter/text_processing/text_detector_painter.dart';

class TextInPictureRecognizerWidget extends StatefulWidget {
  final String imagePath;
  final TextRecognizer textRecognizer;
  final bool showBlocks;
  final bool showLines;
  final bool showElements;

  const TextInPictureRecognizerWidget(
      {Key key,
      @required this.imagePath,
      @required this.textRecognizer,
      this.showBlocks = false,
      this.showLines = false,
      this.showElements = true})
      : super(key: key);

  @override
  _TextInPictureRecognizerWidgetState createState() =>
      _TextInPictureRecognizerWidgetState();
}

class _TextInPictureRecognizerWidgetState
    extends State<TextInPictureRecognizerWidget> {
  VisionText results;

  Future<Size> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    return imageSize;
  }

  String _extractText(VisionText results) {
    String currentText = "";

    for (TextBlock block in results.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          currentText += element.text + " ";
        }
        currentText += "\n\n";
      }
    }

    return currentText;
  }

  Future<CustomPaint> _analyzeText() async {
    File image = File(widget.imagePath);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    results = await widget.textRecognizer.processImage(visionImage);

    TextDetectorPainter painter = TextDetectorPainter(
        await _getImageSize(image), results,
        showBlocks: widget.showBlocks,
        showElements: widget.showElements,
        showLines: widget.showLines);
    return CustomPaint(
      painter: painter,
    );
  }

  void _showRecognizedText() {
    final key = new GlobalKey<ScaffoldState>();

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Scaffold(
            key: key,
            body: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Text in image found",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                IconButton(
                                    icon: Icon(Icons.content_copy),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: _extractText(results)));
                                      key.currentState.showSnackBar(SnackBar(
                                        duration: Duration(seconds: 2),
                                        elevation: 3,
                                        behavior: SnackBarBehavior.floating,
                                        content: Text("Copied to Clipboard"),
                                      ));
                                    })
                              ]),
                          Divider(
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      SelectableText(
                        _extractText(results),
                        textAlign: TextAlign.justify,
                      )
                    ],
                  )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _showRecognizedText();
            },
            child: Text("Show text in image"),
          )
        ],
      ),
      body: FutureBuilder(
        future: _analyzeText(),
        builder: (context, snapshot) {
          return snapshot.connectionState != ConnectionState.done
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Scanning..."),
                      )
                    ],
                  ),
                )
              : Container(
                  constraints: const BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.file(File(widget.imagePath)).image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: snapshot.data,
                );
        },
      ),
    );
  }
}
