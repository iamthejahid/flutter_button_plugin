import 'package:flutter_hardware_buttons/flutter_hardware_buttons_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterHardwareButtonsPlatform extends PlatformInterface {
  FlutterHardwareButtonsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterHardwareButtonsPlatform _instance =
      MethodChannelFlutterHardwareButtons();

  static FlutterHardwareButtonsPlatform get instance => _instance;

  static set instance(FlutterHardwareButtonsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> startListeningForHardwareButtons() {
    throw UnimplementedError(
        'startListeningForHardwareButtons() has not been implemented.');
  }

  Future<void> stopListeningForHardwareButtons() {
    throw UnimplementedError(
        'stopListeningForHardwareButtons() has not been implemented.');
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
