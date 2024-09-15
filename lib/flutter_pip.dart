import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class FlutterPip {
  static const MethodChannel _channel = MethodChannel('flutter_pip');

  static Future<bool> get isPipSupported async {
    final bool isSupported = await _channel.invokeMethod('isPipSupported');
    return isSupported;
  }

  static Future<void> enterPipMode({
    int aspectRatioWidth= 16,
    int aspectRatioHeight = 9,
  }) async {
    try {
      if (Platform.isAndroid) {
        await _channel.invokeMethod('enterPipMode', {
          'aspectRatioNumerator': aspectRatioWidth,
          'aspectRatioDenominator': aspectRatioHeight,
        });
      } else if (Platform.isIOS) {
        await _channel.invokeMethod('startPipMode');
      }
    } on PlatformException catch (e) {
      print("Failed to enter PiP mode: '${e.message}'.");
      rethrow;
    }
  }

  static Future<void> stopPipMode() async {
    if (Platform.isIOS) {
      try {
        await _channel.invokeMethod('stopPipMode');
      } on PlatformException catch (e) {
        print("Failed to stop PiP mode: '${e.message}'.");
        rethrow;
      }
    }
  }
}