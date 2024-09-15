import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class FlutterPip {
  static const MethodChannel _channel = MethodChannel('flutter_pip');
  static const EventChannel _eventChannel = EventChannel('flutter_pip_events');

  /// Checks if Picture-in-Picture mode is supported on the current device.
  static Future<bool> get isPipSupported async {
    final bool isSupported = await _channel.invokeMethod('isPipSupported');
    return isSupported;
  }

  /// Enters Picture-in-Picture mode.
  /// 
  /// For Android, you can specify the aspect ratio of the PiP window.
  /// For iOS, the aspect ratio is determined by the system.
  static Future<void> enterPipMode({
    int aspectRatioWidth = 16,
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

  /// Stops Picture-in-Picture mode.
  /// 
  /// This method is only applicable for iOS. On Android, PiP mode is typically
  /// exited by the user through system controls or by returning to the app.
  static Future<void> stopPipMode() async {
    if (Platform.isIOS) {
      try {
        await _channel.invokeMethod('stopPipMode');
      } on PlatformException catch (e) {
        print("Failed to stop PiP mode: '${e.message}'.");
        rethrow;
      }
    } else {
      print("stopPipMode is only supported on iOS.");
    }
  }

  /// Checks if the app is currently in Picture-in-Picture mode.
  static Future<bool> isPipActive() async {
    try {
      return await _channel.invokeMethod('isPipActive');
    } on PlatformException catch (e) {
      print("Failed to check PiP status: '${e.message}'.");
      rethrow;
    }
  }

  /// Stream of Picture-in-Picture mode changes.
  /// 
  /// Emits `true` when entering PiP mode and `false` when exiting.
  static Stream<bool> get onPipModeChanged {
    return _eventChannel.receiveBroadcastStream().map<bool>((dynamic event) => event as bool);
  }
}