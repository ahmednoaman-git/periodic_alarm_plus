import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'periodic_alarm_plus_platform_interface.dart';

/// An implementation of [PeriodicAlarmPlusPlatform] that uses method channels.
class MethodChannelPeriodicAlarmPlus extends PeriodicAlarmPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('periodic_alarm_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
