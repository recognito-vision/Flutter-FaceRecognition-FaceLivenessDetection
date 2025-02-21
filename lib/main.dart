// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'settings.dart';
import 'person.dart';
import 'personview.dart';
import 'facedetectionview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FaceDemo',
        theme: ThemeData(
          // Define the default brightness and colors.
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        home: MyHomePage(title: 'FaceDemo'));
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  final String title;
  var personList = <Person>[];

  MyHomePage({super.key, required this.title});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String _warningState = "";
  bool _visibleWarning = false;

  final _facesdkPlugin = FacesdkPlugin();

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    int facepluginState = -1;
    String warningState = "";
    bool visibleWarning = false;

    try {
      if (Platform.isAndroid) {
        await _facesdkPlugin
            .setActivation(
                "EO5wcxhdMXJoLRpKq3Lexv2sTHPU8Ehed3vsBwmzdye/MJw+rVJTnY9SidD3vKV/2YNE6kufwIcC"
                "7LvLGFSORk3b14swPe7415aYSLKNI2RaUL5Nfn9oWHBjW1XehQLjLUx3w0Qi8bUth6vyg9Oaj7V7"
                "+dKruxjx/2dD2ddXKBoiIwYDonjW7gx7PmF9W66DXDtfRGpARvKW5Cn+jSCCH8A3Gft8wOBdQXM8"
                "UTDZUZxNbvozkgV6Dw9hMQJSka06iFK1h/UO6NrGLudt1SOC2b3hfoFJcAVjl3W7UTxzVyByJpLp"
                "tYTWJNr36pn1ixWhazLHC4s4TXtyQR67yzN3aw==")
            .then((value) => facepluginState = value ?? -1);
      } else {
        await _facesdkPlugin
            .setActivation(
                "H/Fs6Zgbsi9av6VVDAi54yqpYxnq0eDV3MSZAxMnARvUVePNY85UJu3d95nM7iO2RrCm19/eq+qb"
                "gSDmhJRYVJBMEUcxG+0cPPWVAW7m46dfS1Kpn+Flqbanfbco+Hd9Uda3aAzDkklzgdfYt7TvSXRt"
                "LZ8wW7jLiPjt8Lufj1GvhRzfESARv18VrxfQV+U8x3EqqvfKTJrkkg91NuAKvUZSoao4B5pQLpRd"
                "GwQ/saP9AQSWuyU1Zw+Whw/cnmXY2xZLGx6n/ict3NW9vpttv2tBbPCe/TdofRuJbE7R1Yb60BvQ"
                "ajzoaQWx3RsRgca9ah+Pccxb15tPVzr1apTK7A==")
            .then((value) => facepluginState = value ?? -1);
      }

      if (facepluginState == 0) {
        await _facesdkPlugin
            .init()
            .then((value) => facepluginState = value ?? -1);
      }
    } catch (e) {}

    List<Person> personList = await loadAllPersons();
    await SettingsPageState.initSettings();

    final prefs = await SharedPreferences.getInstance();
    int? livenessLevel = prefs.getInt("liveness_level");

    try {
      await _facesdkPlugin
          .setParam({'check_liveness_level': livenessLevel ?? 0});
    } catch (e) {}

    if (!mounted) return;

    if (facepluginState == -1) {
      warningState = "License key error!";
      visibleWarning = true;
    } else if (facepluginState == -2) {
      warningState = "License key expired!";
      visibleWarning = true;
    } else if (facepluginState == -3) {
      warningState = "Invalid license!";
      visibleWarning = true;
    } else if (facepluginState == -4) {
      warningState = "Activation failed!";
      visibleWarning = true;
    } else if (facepluginState == -5) {
      warningState = "Engine init error!";
      visibleWarning = true;
    }

    setState(() {
      _warningState = warningState;
      _visibleWarning = visibleWarning;
      widget.personList = personList;
    });
  }

  Future<Database> createDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'person.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE person(name text, faceJpg blob, templates blob)',
        );
      },
      version: 1,
    );

    return database;
  }

  Future<List<Person>> loadAllPersons() async {
    final db = await createDB();
    final List<Map<String, dynamic>> maps = await db.query('person');
    return List.generate(maps.length, (i) {
      return Person.fromMap(maps[i]);
    });
  }

  Future<void> insertPerson(Person person) async {
    final db = await createDB();
    await db.insert(
      'person',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    setState(() {
      widget.personList.add(person);
    });
  }

  Future<void> deleteAllPerson() async {
    final db = await createDB();
    await db.delete('person');

    setState(() {
      widget.personList.clear();
    });

    Fluttertoast.showToast(
        msg: "Removed all users",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFFFDB528),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> deletePerson(index) async {
    final db = await createDB();
    await db.delete('person',
        where: 'name=?', whereArgs: [widget.personList[index].name]);

    setState(() {
      widget.personList.removeAt(index);
    });

    Fluttertoast.showToast(
        msg: "Removed user!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFFFDB528),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future enrollPerson() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      var rotatedImage =
          await FlutterExifRotation.rotateImage(path: image.path);

      final faces = await _facesdkPlugin.extractFaces(rotatedImage.path);
      for (var face in faces) {
        DateTime now = DateTime.now();
        String formattedDateTime = DateFormat('yyyyMMddHHmmss').format(now);
        Person person = Person(
            name: 'User $formattedDateTime',
            faceJpg: face['faceJpg'],
            templates: face['templates']);
        insertPerson(person);
      }

      if (faces.length == 0) {
        Fluttertoast.showToast(
            msg: "No face!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xFFFDB528),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Registered user successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xFFFDB528),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('FACE RECOGNITION', style: TextStyle(fontSize: 30, color: Color(0xFFFDB528), fontWeight: FontWeight.bold)),
            toolbarHeight: 150,
            centerTitle: true,
          ),
      
          body: Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: enrollPerson,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 46),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          backgroundColor: const Color(0xFFFDB528),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(23.0)),
                          ),
                        ),
                        child: const Text('Register', style: TextStyle(fontSize: 15, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FaceRecognitionView(
                                      personList: widget.personList,
                                    )),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 46),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          backgroundColor: const Color(0xFFFDB528),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(23.0)),
                          ),
                        ),
                        child: const Text('Identify', style: TextStyle(fontSize: 15, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                Expanded(
                  child: Stack(
                    children: [
                      PersonView(
                        personList: widget.personList,
                        homePageState: this,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Visibility(
                            visible: _visibleWarning,
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              color: Colors.redAccent,
                              child: Center(
                                child: Text(_warningState, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20)),
                              ),
                            )
                          )
                        ],
                      )
                    ],
                  )
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        Positioned(
          top: 40, right: 16,
          child: IconButton(
            icon: Image.asset('assets/ic_setting.png',  width: 32, height: 32),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    homePageState: this,
                  )
                ),
              );
            },
          ),
        ),
      ]
    );
  }
}
