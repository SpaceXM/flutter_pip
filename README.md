# flutter_pip

A Flutter plugin for implementing Picture-in-Picture (PiP) functionality on both Android and iOS platforms.

## Features

- Check if PiP is supported on the current device
- Enter PiP mode on Android with customizable aspect ratio
- Start and stop PiP mode on iOS
- Cross-platform support (Android and iOS)

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_pip:
    git:
      url: https://github.com/SpaceXM/flutter_pip.git
```

### Usage

First, import the package:

```dart
import 'package:flutter_pip/flutter_pip.dart';
```

Then, you can use it as follows:

```dart
// Check if PiP is supported
bool isPipSupported = await FlutterPip.isPipSupported;

// Enter PiP mode (Android)
if (Platform.isAndroid) {
  await FlutterPip.enterPipMode(
    aspectRatioWidth: 16,
    aspectRatioHeight: 9,
  );
}

// Start PiP mode (iOS)
if (Platform.isIOS) {
  await FlutterPip.startPipMode();
}

// Stop PiP mode (iOS)
if (Platform.isIOS) {
  await FlutterPip.stopPipMode();
}
```

## Platform-specific Setup

### Android

Add the following to your app's `AndroidManifest.xml` file, inside the `<activity>` tag:

```xml
android:supportsPictureInPicture="true"
android:configChanges="screenSize|smallestScreenSize|screenLayout|orientation"
```

### iOS

1. In Xcode, select your project in the navigator.
2. Select your target, then select the "Signing & Capabilities" tab.
3. Click the "+ Capability" button.
4. Add the "Background Modes" capability.
5. Check the box for "Audio, AirPlay, and Picture in Picture".

## Example

For a complete example, please see the `example` folder in this repository.

## Limitations

- On iOS, PiP is typically used with video content. Make sure you have a video player implemented in your app for the best experience.
- The aspect ratio setting is only applicable for Android. On iOS, the system handles the PiP window size automatically.

## Contributing

Contributions are welcome! If you find a bug or want a feature, please open an issue.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
