import 'dart:async';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class ImageClassifyingPage extends StatefulWidget {
  final String imagePath;
  final ImageLabeler imageLabeler;

  const ImageClassifyingPage({
    Key key,
    @required this.imagePath,
    @required this.imageLabeler,
  }) : super(key: key);

  @override
  _ImageClassifyingPageState createState() => _ImageClassifyingPageState();
}

class _ImageClassifyingPageState extends State<ImageClassifyingPage> {
  Future<List<ImageLabel>> _analyzeImage() async {
    FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(File(widget.imagePath));
    List<ImageLabel> labels =
        await widget.imageLabeler.processImage(visionImage);
    return labels;
  }

  Widget _loading() {
    return Center(
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
    );
  }

  Widget _labelsReport(List<ImageLabel> labels) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.black.withOpacity(0.75)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: labels.map((label) {
              return Text(
                label.text +
                    " at " +
                    (label.confidence * 100).toStringAsFixed(1) +
                    "%",
                style: TextStyle(fontSize: 17),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _analyzeImage(),
        builder: (context, snapshot) {
          return snapshot.connectionState != ConnectionState.done
              ? _loading()
              : Stack(
                  children: <Widget>[
                    Container(
                      constraints: const BoxConstraints.expand(),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Image.file(File(widget.imagePath)).image,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: _labelsReport(snapshot.data),
                    )
                  ],
                );
        },
      ),
    );
  }
}
