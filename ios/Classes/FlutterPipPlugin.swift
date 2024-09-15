import Flutter
import UIKit
import AVKit

@objc public class FlutterPipPlugin: NSObject, FlutterPlugin {
    private var pipController: AVPictureInPictureController?
    private var eventSink: FlutterEventSink?
    private var methodChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_pip", binaryMessenger: registrar.messenger())
        let instance = FlutterPipPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventChannel = FlutterEventChannel(name: "flutter_pip_events", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
        
        instance.methodChannel = channel
        instance.eventChannel = eventChannel
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isPipSupported":
            result(AVPictureInPictureController.isPictureInPictureSupported())
        case "startPipMode":
            startPipMode(result: result)
        case "stopPipMode":
            stopPipMode(result: result)
        case "isPipActive":
            result(pipController?.isPictureInPictureActive ?? false)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func startPipMode(result: @escaping FlutterResult) {
        guard AVPictureInPictureController.isPictureInPictureSupported() else {
            result(FlutterError(code: "PIP_NOT_SUPPORTED", message: "Picture in Picture is not supported on this device", details: nil))
            return
        }

        if pipController == nil {
            let playerLayer = AVPlayerLayer(player: AVPlayer())
            pipController = AVPictureInPictureController(playerLayer: playerLayer)
            pipController?.delegate = self
        }

        guard let pipController = pipController else {
            result(FlutterError(code: "PIP_CONTROLLER_UNAVAILABLE", message: "Unable to create PiP controller", details: nil))
            return
        }

        if pipController.isPictureInPicturePossible {
            pipController.startPictureInPicture()
            result(nil)
        } else {
            result(FlutterError(code: "PIP_NOT_POSSIBLE", message: "Picture in Picture is not possible at this time", details: nil))
        }
    }

    private func stopPipMode(result: @escaping FlutterResult) {
        guard let pipController = pipController else {
            result(FlutterError(code: "PIP_CONTROLLER_UNAVAILABLE", message: "PiP controller not initialized", details: nil))
            return
        }

        if pipController.isPictureInPictureActive {
            pipController.stopPictureInPicture()
            result(nil)
        } else {
            result(FlutterError(code: "PIP_NOT_ACTIVE", message: "Picture in Picture is not currently active", details: nil))
        }
    }
}

extension FlutterPipPlugin: AVPictureInPictureControllerDelegate {
    public func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        eventSink?(true)
    }
    
    public func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        eventSink?(false)
    }
}

extension FlutterPipPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}