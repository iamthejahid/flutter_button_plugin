import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_hardware_buttons/flutter_hardware_buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterHardwareButtonsPlugin = FlutterHardwareButtons();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion =
          await _flutterHardwareButtonsPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  // Start listening for hardware buttons
  Future<void> startListening() async {
    try {
      await _flutterHardwareButtonsPlugin.startListeningForHardwareButtons();
    } on PlatformException catch (e) {
      print('Error starting hardware button listener: $e');
    }
  }

  // Stop listening for hardware buttons
  Future<void> stopListening() async {
    try {
      await _flutterHardwareButtonsPlugin.stopListeningForHardwareButtons();
    } on PlatformException catch (e) {
      print('Error stopping hardware button listener: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                onPressed: startListening,
                child: Text('Start Listening'),
              ),
              ElevatedButton(
                onPressed: stopListening,
                child: Text('Stop Listening'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
