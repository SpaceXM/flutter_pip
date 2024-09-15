import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_pip/flutter_pip.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isPipSupported = false;

  @override
  void initState() {
    super.initState();
    _checkPipSupport();
  }

  Future<void> _checkPipSupport() async {
    bool isPipSupported;
    try {
      isPipSupported = await FlutterPip.isPipSupported;
    } catch (e) {
      isPipSupported = false;
      print('Error checking PiP support: $e');
    }

    if (!mounted) return;

    setState(() {
      _isPipSupported = isPipSupported;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PiP Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('PiP Supported: $_isPipSupported'),
              const SizedBox(height: 20),
              if (_isPipSupported) ...[
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (Platform.isAndroid) {
                        await FlutterPip.enterPipMode(
                          aspectRatioWidth: 16,
                          aspectRatioHeight: 9,
                        );
                      } else if (Platform.isIOS) {
                        await FlutterPip.enterPipMode();
                      }
                    } catch (e) {
                      print('Error entering PiP mode: $e');
                    }
                  },
                  child: Text(Platform.isAndroid ? 'Enter PiP Mode' : 'Start PiP Mode'),
                ),
                if (Platform.isIOS) ...[
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await FlutterPip.stopPipMode();
                      } catch (e) {
                        print('Error stopping PiP mode: $e');
                      }
                    },
                    child: const Text('Stop PiP Mode'),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}