import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:facesdk_plugin/facedetection_interface.dart';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'person.dart';

// ignore: must_be_immutable
class FaceRecognitionView extends StatefulWidget {
  final List<Person> personList;
  FaceDetectionViewController? faceDetectionViewController;

  FaceRecognitionView({super.key, required this.personList});

  @override
  State<StatefulWidget> createState() => FaceRecognitionViewState();
}

class FaceRecognitionViewState extends State<FaceRecognitionView> {
  int _cameraLens = 1;  // 0 for back camera, 1 for front camera 
  dynamic _faces;
  double _livenessThreshold = 0;
  double _identifyThreshold = 0;
  bool _recognized = false;
  double _identifiedSimilarity = 0.0;
  String _identifiedName = "";
  String _identifiedLiveness = "";
  String _identifiedYaw = "";
  String _identifiedRoll = "";
  String _identifiedPitch = "";
  // ignore: prefer_typing_uninitialized_variables
  var _identifiedFace;
  // ignore: prefer_typing_uninitialized_variables
  var _enrolledFace;
  final _facesdkPlugin = FacesdkPlugin();
  FaceDetectionViewController? faceDetectionViewController;

  @override
  void initState() {
    super.initState();

    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? livenessThreshold = prefs.getString("liveness_threshold");
    String? identifyThreshold = prefs.getString("identify_threshold");
    setState(() {
      _livenessThreshold = double.parse(livenessThreshold ?? "0.7");
      _identifyThreshold = double.parse(identifyThreshold ?? "0.8");
    });
  }

  Future<void> faceRecognitionStart() async {
    setState(() {
      _faces = null;
      _recognized = false;
    });

    await faceDetectionViewController?.startCamera(_cameraLens);
  }

  Future<void> switchCamera() async {
    // Toggle between front (0) and back (1) camera
    _cameraLens = _cameraLens == 0 ? 1 : 0;
    faceDetectionViewController?.stopCamera();
    await faceDetectionViewController?.startCamera(_cameraLens);
  }

  Future<bool> onFaceDetected(faces) async {
    if (_recognized == true) {
      return false;
    }

    if (!mounted) return false;

    setState(() {
      _faces = faces;
    });

    bool recognized = false;
    double maxSimilarity = -1;
    String maxSimilarityName = "";
    double maxLiveness = -1;
    double maxYaw = -1;
    double maxRoll = -1;
    double maxPitch = -1;
    // ignore: prefer_typing_uninitialized_variables
    var enrolledFace, identifedFace;
    if (faces.length > 0) {
      var face = faces[0];
      for (var person in widget.personList) {
        double similarity = await _facesdkPlugin.similarityCalculation(
                face['templates'], person.templates) ??
            -1;
        if (maxSimilarity < similarity) {
          maxSimilarity = similarity;
          maxSimilarityName = person.name;
          maxLiveness = face['liveness'];
          maxYaw = face['yaw'];
          maxRoll = face['roll'];
          maxPitch = face['pitch'];
          identifedFace = face['faceJpg'];
          enrolledFace = person.faceJpg;
        }
      }

      if (maxSimilarity > _identifyThreshold &&
          maxLiveness > _livenessThreshold) {
        recognized = true;
      }
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return false;
      setState(() {
        _recognized = recognized;
        _identifiedName = maxSimilarityName;
        _identifiedSimilarity = maxSimilarity;
        _identifiedLiveness = maxLiveness.toStringAsFixed(4);
        _identifiedYaw = maxYaw.toStringAsFixed(4);
        _identifiedRoll = maxRoll.toStringAsFixed(4);
        _identifiedPitch = maxPitch.toStringAsFixed(4);
        _enrolledFace = enrolledFace;
        _identifiedFace = identifedFace;
      });
      if (recognized) {
        faceDetectionViewController?.stopCamera();
        setState(() {
          _faces = null;
        });
      }
    });

    return recognized;
  }

  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        faceDetectionViewController?.stopCamera();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Face Recognition', style: TextStyle(fontSize: 24, color: Color(0xFFFDB528), fontWeight: FontWeight.bold)),
          toolbarHeight: 70,
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            FaceDetectionView(faceRecognitionViewState: this),
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CustomPaint(
                painter: FacePainter(
                    faces: _faces, livenessThreshold: _livenessThreshold),
              ),
            ),

            Positioned(
              bottom: 40, left: 0, right: 0,
              child: IconButton(
                icon: Image.asset('assets/ic_camera_flip.png', width: 32, height: 32),
                onPressed: () => switchCamera(),
              ),
            ),

            Visibility(
              visible: _recognized,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _identifiedFace != null
                            ? Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(70.0),
                                    child: Image.memory(_identifiedFace, width: 140, height: 140),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text('Identified')
                                ],
                              )
                            : const SizedBox(height: 1),
                        Center(
                          child: CircularPercentIndicator(
                            radius: 35.0,
                            lineWidth: 7.0,
                            percent: _identifiedSimilarity.clamp(0.0, 1.0), 
                            center: Text("${(_identifiedSimilarity*100).toStringAsFixed(1)}%"),
                            progressColor: const Color(0xFFFDB528),
                            backgroundColor: Colors.grey[300]!,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                        ),
                        _enrolledFace != null
                            ? Column(
                                children: [
                                  ClipRRect(
                                    borderRadius:BorderRadius.circular(70.0),
                                    child: Image.memory(_enrolledFace, width: 140, height: 140),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(_identifiedName)
                                ],
                              )
                            : const SizedBox(height: 1),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row( 
                      children: [
                        Expanded(flex: 1, child: Container()),
                        const Expanded(
                          flex: 2, 
                          child: Align(
                            alignment: Alignment.centerLeft, 
                            child: Text('Liveness score: ', style: TextStyle(fontSize: 18, color: Color(0xFFFDB528))),
                          ),
                        ),
                        Expanded(
                          flex: 2, 
                          child: Align(
                            alignment: Alignment.centerRight, 
                            child: Text(_identifiedLiveness, style: const TextStyle(fontSize: 18)),
                          ),
                        ),
                        Expanded(flex: 1, child: Container()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row( 
                      children: [
                        Expanded(flex: 1, child: Container()),
                        const Expanded(
                          flex: 2, 
                          child: Align(
                            alignment: Alignment.centerLeft, 
                            child: Text('Yaw: ', style: TextStyle(fontSize: 18, color: Color(0xFFFDB528))),
                          ),
                        ),
                        Expanded(
                          flex: 2, 
                          child: Align(
                            alignment: Alignment.centerRight, 
                            child: Text(_identifiedYaw, style: const TextStyle(fontSize: 18)),
                          ),
                        ),
                        Expanded(flex: 1, child: Container()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row( 
                      children: [
                        Expanded(flex: 1, child: Container()),
                        const Expanded(
                          flex: 2, 
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Roll: ', style: TextStyle(fontSize: 18, color: Color(0xFFFDB528))),
                          ),
                        ),
                        Expanded(
                          flex: 2, 
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(_identifiedRoll, style: const TextStyle(fontSize: 18)),
                          ),
                        ),
                        Expanded(flex: 1, child: Container()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row( 
                      children: [
                        Expanded(flex: 1, child: Container()),
                        const Expanded(
                          flex: 2, 
                          child: Align(
                            alignment: Alignment.centerLeft, 
                            child: Text('Pitch: ', style: TextStyle(fontSize: 18, color: Color(0xFFFDB528))),
                          ),
                        ),
                        Expanded(
                          flex: 2, 
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(_identifiedPitch, style: const TextStyle(fontSize: 18)),
                          ),
                        ),
                        Expanded(flex: 1, child: Container()),
                      ],
                    ),
                    Expanded(child: Container()), 
                    Padding(
                      padding: const EdgeInsets.all(32.0), 
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: faceRecognitionStart,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 46),
                            backgroundColor: const Color(0xFFFDB528),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(23.0)),
                            ),
                          ),
                          child: const Text('Try again', style: TextStyle(fontSize: 15, color: Colors.white)),
                        ),
                      ),
                    )
                  ]
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class FaceDetectionView extends StatefulWidget
    implements FaceDetectionInterface {
  FaceRecognitionViewState faceRecognitionViewState;

  FaceDetectionView({super.key, required this.faceRecognitionViewState});

  @override
  Future<void> onFaceDetected(faces) async {
    await faceRecognitionViewState.onFaceDetected(faces);
  }

  @override
  State<StatefulWidget> createState() => _FaceDetectionViewState();
}

class _FaceDetectionViewState extends State<FaceDetectionView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'facedetectionview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      return UiKitView(
        viewType: 'facedetectionview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
  }

  void _onPlatformViewCreated(int id) async {
    final prefs = await SharedPreferences.getInstance();

    widget.faceRecognitionViewState.faceDetectionViewController =
        FaceDetectionViewController(id, widget);

    await widget.faceRecognitionViewState.faceDetectionViewController
        ?.initHandler();

    int? livenessLevel = prefs.getInt("liveness_level");
    await widget.faceRecognitionViewState._facesdkPlugin
        .setParam({'check_liveness_level': livenessLevel ?? 0});


    await widget.faceRecognitionViewState.faceDetectionViewController
        ?.startCamera(widget.faceRecognitionViewState._cameraLens);
  }
}

class FacePainter extends CustomPainter {
  dynamic faces;
  double livenessThreshold;
  FacePainter({required this.faces, required this.livenessThreshold});

  void drawBBox(Canvas canvas, Paint paint, Rect rect) {
    // Left top corner
    double lineLength = 60;
    double radius = 15;
    final leftTopArcRect = Rect.fromLTRB(
      rect.left, 
      rect.top, 
      rect.left + radius * 2, 
      rect.top + radius * 2
    );
    canvas.drawLine(Offset(rect.left, rect.top + lineLength), Offset(rect.left, rect.top + radius), paint);
    canvas.drawArc(leftTopArcRect, 3.14, 1.57, false, paint); // 180 degrees (PI) to 90 degrees
    canvas.drawLine(Offset(rect.left + radius, rect.top), Offset(rect.left + lineLength, rect.top), paint);

    // Right top corner
    final rightTopArcRect = Rect.fromLTRB(
      rect.right - radius * 2, 
      rect.top, 
      rect.right, 
      rect.top + radius * 2
    );
    canvas.drawLine(Offset(rect.right - lineLength, rect.top), Offset(rect.right - radius, rect.top), paint);
    canvas.drawArc(rightTopArcRect, 4.71, 1.57, false, paint); // 270 degrees (3*PI/2) to 90 degrees
    canvas.drawLine(Offset(rect.right, rect.top + radius), Offset(rect.right, rect.top + lineLength), paint);

    // Left bottom corner
    final leftBottomArcRect = Rect.fromLTRB(
      rect.left, 
      rect.bottom - radius * 2, 
      rect.left + radius * 2, 
      rect.bottom
    );
    canvas.drawLine(Offset(rect.left, rect.bottom - lineLength), Offset(rect.left, rect.bottom - radius), paint);
    canvas.drawArc(leftBottomArcRect, 3.14, -1.57, false, paint); // 180 degrees (PI) to -90 degrees
    canvas.drawLine(Offset(rect.left + radius, rect.bottom), Offset(rect.left + lineLength, rect.bottom), paint);

    // Right bottom corner
    final rightBottomArcRect = Rect.fromLTRB(
      rect.right - radius * 2, 
      rect.bottom - radius * 2, 
      rect.right, 
      rect.bottom
    );
    canvas.drawLine(Offset(rect.right - lineLength, rect.bottom), Offset(rect.right - radius, rect.bottom), paint);
    canvas.drawArc(rightBottomArcRect, 1.57, -1.57, false, paint); // 90 degrees (PI/2) to -90 degrees
    canvas.drawLine(Offset(rect.right, rect.bottom - radius), Offset(rect.right, rect.bottom - lineLength), paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (faces != null) {
      var paint = Paint();
      paint.color = const Color.fromARGB(0xff, 0xff, 0, 0);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 3;

      for (var face in faces) {
        double xScale = face['frameWidth'] / size.width;
        double yScale = face['frameHeight'] / size.height;

        String title = "";
        Color color = const Color.fromARGB(0xff, 0xff, 0, 0);
        if (face['liveness'] < livenessThreshold) {
          color = const Color.fromARGB(0xff, 0xff, 0, 0);
          title = "SPOOF ${face['liveness'].toStringAsFixed(3)}";
        } else {
          color = const Color(0xFFFDB528);
          title = "REAL ${face['liveness'].toStringAsFixed(3)}";
        }

        TextSpan span =
            TextSpan(style: TextStyle(color: color, fontSize: 20), text: title);
        TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, Offset(face['x1'] / xScale, face['y1'] / yScale - 30));

        paint.color = color;
        drawBBox(canvas, paint, Rect.fromLTRB(face['x1'] / xScale, face['y1'] / yScale, face['x2'] / xScale, face['y2'] / yScale));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
