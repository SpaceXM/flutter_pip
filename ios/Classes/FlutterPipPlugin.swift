import Flutter
import UIKit
import AVKit

public class SwiftMyPipPackagePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "my_pip_package", binaryMessenger: registrar.messenger())
    let instance = SwiftMyPipPackagePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isPipSupported":
      result(AVPictureInPictureController.isPictureInPictureSupported())
    case "startPipMode":
      startPipMode()
      result(nil)
    case "stopPipMode":
      stopPipMode()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func startPipMode() {
    if let pipController = AVPictureInPictureController.shared {
      if pipController.isPictureInPicturePossible {
        pipController.startPictureInPicture()
      }
    }
  }

  private func stopPipMode() {
    if let pipController = AVPictureInPictureController.shared {
      if pipController.isPictureInPictureActive {
        pipController.stopPictureInPicture()
      }
    }
  }
}