import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'periodic_alarm_plus_method_channel.dart';

abstract class PeriodicAlarmPlusPlatform extends PlatformInterface {
  /// Constructs a PeriodicAlarmPlusPlatform.
  PeriodicAlarmPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static PeriodicAlarmPlusPlatform _instance = MethodChannelPeriodicAlarmPlus();

  /// The default instance of [PeriodicAlarmPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelPeriodicAlarmPlus].
  static PeriodicAlarmPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PeriodicAlarmPlusPlatform] when
  /// they register themselves.
  static set instance(PeriodicAlarmPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
