import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  final MyHomePageState homePageState;

  const SettingsPage({super.key, required this.homePageState});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class LivenessDetectionLevel {
  String levelName;
  int levelValue;

  LivenessDetectionLevel(this.levelName, this.levelValue);
}

const double _kItemExtent = 40.0;
const List<String> _livenessLevelNames = <String>[
  'v1', // More Accurate mode
  'v2-fast', // More Light mode
];

class SettingsPageState extends State<SettingsPage> {
  String _livenessThreshold = "0.7";
  String _identifyThreshold = "0.8";
  List<LivenessDetectionLevel> livenessDetectionLevel = [
    LivenessDetectionLevel('v1', 0),
    LivenessDetectionLevel('v2-fast', 1),
  ];
  int _selectedLivenessLevel = 0;

  final livenessController = TextEditingController();
  final identifyController = TextEditingController();

  static Future<void> initSettings() async {
    final prefs = await SharedPreferences.getInstance();
    var firstWrite = prefs.getInt("first_write");
    if (firstWrite == 0) {
      await prefs.setInt("first_write", 1);
      await prefs.setInt("liveness_level", 0);
      await prefs.setString("liveness_threshold", "0.7");
      await prefs.setString("identify_threshold", "0.8");
    }
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    var livenessLevel = prefs.getInt("liveness_level");
    var livenessThreshold = prefs.getString("liveness_threshold");
    var identifyThreshold = prefs.getString("identify_threshold");

    setState(() {
      _livenessThreshold = livenessThreshold ?? "0.7";
      _identifyThreshold = identifyThreshold ?? "0.8";
      _selectedLivenessLevel = livenessLevel ?? 0;
      livenessController.text = _livenessThreshold;
      identifyController.text = _identifyThreshold;
    });
  }

  Future<void> restoreSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("first_write", 0);
    await initSettings();
    await loadSettings();

    // Fluttertoast.showToast(
    //     msg: "Default settings restored!",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  Future<void> updateLivenessLevel(value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("liveness_level", value);
  }

  Future<void> updateLivenessThreshold(BuildContext context) async {
    try {
      var doubleValue = double.parse(livenessController.text);
      if (doubleValue >= 0 && doubleValue < 1.0) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("liveness_threshold", livenessController.text);

        setState(() {
          _livenessThreshold = livenessController.text;
        });
      }
    } catch (e) {}

    // ignore: use_build_context_synchronously
    Navigator.pop(context, 'OK');
    setState(() {
      livenessController.text = _livenessThreshold;
    });
  }

  Future<void> updateIdentifyThreshold(BuildContext context) async {
    try {
      var doubleValue = double.parse(identifyController.text);
      if (doubleValue >= 0 && doubleValue < 1.0) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("identify_threshold", identifyController.text);

        setState(() {
          _identifyThreshold = identifyController.text;
        });
      }
    } catch (e) {}

    // ignore: use_build_context_synchronously
    Navigator.pop(context, 'OK');
    setState(() {
      identifyController.text = _identifyThreshold;
    });
  }

// This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Color(0xFFFDB528), fontWeight: FontWeight.bold)),
        toolbarHeight: 100,
        centerTitle: true,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Matching threshold', style: TextStyle(fontSize: 15, color:  Color(0xFFFDB528))),
                    Text(_identifyThreshold, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
                onPressed: (value) => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Matching threshold', style: TextStyle(fontSize: 18, color: Color(0xFFFDB528))),
                    content: TextField(
                      controller: identifyController,
                      onChanged: (value) => {},
                    ),
                    actions: <Widget>[
                      TextButton(onPressed: () => Navigator.pop(context, 'Cancel'), child: const Text('Cancel')),
                      TextButton(onPressed: () => updateIdentifyThreshold(context), child: const Text('OK')),
                    ],
                  ),
                ),
              ),
              SettingsTile.navigation(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Liveness threshold', style: TextStyle(fontSize: 15, color:  Color(0xFFFDB528))),
                    Text(_livenessThreshold, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
                onPressed: (value) => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Liveness threshold', style: TextStyle(fontSize: 18, color: Color(0xFFFDB528))),
                    content: TextField(
                      controller: livenessController,
                      onChanged: (value) => {},
                    ),
                    actions: <Widget>[
                      TextButton(onPressed: () => Navigator.pop(context, 'Cancel'), child: const Text('Cancel')),
                      TextButton(onPressed: () => updateLivenessThreshold(context), child: const Text('OK')),
                    ],
                  ),
                ),
              ),
              SettingsTile.navigation(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Liveness model', style: TextStyle(fontSize: 15, color:  Color(0xFFFDB528)),),
                    Text(_livenessLevelNames[_selectedLivenessLevel], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ],
                ),
                onPressed: (value) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      int selectedLevel = _selectedLivenessLevel; // Temporary variable for selection
                      return AlertDialog(
                        title: const Text('Liveness model', style: TextStyle(fontSize: 18, color: Color(0xFFFDB528))),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(_livenessLevelNames.length, (int index) {
                            return RadioListTile<int>(
                              title: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(_livenessLevelNames[index]),
                              ),
                              contentPadding: EdgeInsets.zero,
                              value: index,
                              groupValue: selectedLevel,
                              onChanged: (int? value) {
                                if (value != null) {
                                  selectedLevel = value;
                                  setState(() {
                                    _selectedLivenessLevel = value;
                                  });
                                  Navigator.pop(context); 
                                  updateLivenessLevel(value);
                                }
                              },
                            );
                          }),
                        ),
                      );
                    },
                  );
                }
              ),
              SettingsTile.navigation(
                title: const Text('Reset settings', style: TextStyle(fontSize: 15, color:  Color(0xFFFDB528))),
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text('Are you sure you want to reset all settings?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              restoreSettings(); 
                            },
                            child: const Text('Yes', style: TextStyle(color: Colors.red)), 
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SettingsTile.navigation(
                title: const Text('Remove registered users', style: TextStyle(fontSize: 15, color:  Color(0xFFFDB528))),
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text('Are you sure you want to remove all users?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context), 
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); 
                              widget.homePageState.deleteAllPerson();
                            },
                            child: const Text('Yes', style: TextStyle(color: Colors.red)), 
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
