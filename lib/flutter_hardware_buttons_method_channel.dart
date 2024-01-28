import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_hardware_buttons_platform_interface.dart';

/// An implementation of [FlutterHardwareButtonsPlatform] that uses method channels.
class MethodChannelFlutterHardwareButtons
    extends FlutterHardwareButtonsPlatform {
  final MethodChannel _methodChannel =
      const MethodChannel('flutter_hardware_buttons');

  @override
  Future<void> startListeningForHardwareButtons() async {
    await _methodChannel.invokeMethod<void>('startListeningForHardwareButtons');
  }

  @override
  Future<void> stopListeningForHardwareButtons() async {
    await _methodChannel.invokeMethod<void>('stopListeningForHardwareButtons');
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await _methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
