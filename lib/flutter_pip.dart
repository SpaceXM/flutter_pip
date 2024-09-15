import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class MyPipPackage {
  static const MethodChannel _channel = MethodChannel('my_pip_package');

  static Future<bool> get isPipSupported async {
    final bool isSupported = await _channel.invokeMethod('isPipSupported');
    return isSupported;
  }

  static Future<void> enterPipMode({
    int aspectRatioWidth = 16,
    int aspectRatioHeight = 9,
  }) async {
    await _channel.invokeMethod('enterPipMode', {
      'aspectRatioNumerator': aspectRatioWidth,
      'aspectRatioDenominator': aspectRatioHeight,
    });
  }

  static Future<void> startPipMode() async {
    if (Platform.isIOS) {
      await _channel.invokeMethod('startPipMode');
    }
  }

  static Future<void> stopPipMode() async {
    if (Platform.isIOS) {
      await _channel.invokeMethod('stopPipMode');
    }
  }
}