import 'dart:async';
import 'dart:io';
import 'package:periodic_alarm_plus/model/alarms_model.dart';
import 'package:periodic_alarm_plus/services/alarm_notification.dart';
import 'package:periodic_alarm_plus/services/alarm_storage.dart';
import 'package:periodic_alarm_plus/src/android_alarm.dart';

const alarmNumber = 8;

class PeriodicAlarmPlus {
  static bool get iOS => Platform.isIOS;

  static bool get android => Platform.isAndroid;

  static final ringStream = StreamController<AlarmModel>();

  static Future<void> init() async {
    await Future.wait([
      if (android) AndroidAlarm.init(),
      AlarmNotification.instance.init(),
      AlarmStorage.init(),
    ]);
  }

  static Future<void> dispose() async {
    await Future.wait([AndroidAlarm.audioPlayer.dispose(), ringStream.close()]);
  }

  static Future<bool> setOneAlarm({required AlarmModel alarmModel}) async {
    await AlarmStorage.saveAlarm(alarmModel);

    if (alarmModel.enableNotificationOnKill) {
      await AlarmNotification.instance.requestPermission();
    }

    return await AndroidAlarm.setOneAlarm(
        alarmModel, () => ringStream.add(alarmModel));
  }

  static Future<bool> setPeriodicAlarm({required AlarmModel alarmModel}) async {
    await AlarmStorage.saveAlarm(alarmModel);

    if (alarmModel.enableNotificationOnKill) {
      await AlarmNotification.instance.requestPermission();
    }

    return await AndroidAlarm.setPeriodicAlarm(
        alarmModel, () => ringStream.add(alarmModel));
  }

  static Future<bool> stop(int id) async {
    AlarmNotification.instance.cancel(id);

    return await AndroidAlarm.stop(id);
  }

  static Future<bool> cancelAlarm(int alarmId) async {
    bool isCanceledAlarm = await AndroidAlarm.cancelAlarm(alarmId);
    AlarmNotification.instance.cancel(alarmId);

    return isCanceledAlarm;
  }

  static void saveAlarm(AlarmModel alarmModel) {
    AlarmStorage.saveAlarm(alarmModel);
  }

  static Future<bool> deleteAlarm(int alarmId) async {
    bool isDeletedAlarm = await AlarmStorage.deleteAlarm(alarmId);

    return isDeletedAlarm;
  }

  static Future<bool> saveActiveAlarmStatu(int id, bool active) async {
    bool res = await AlarmStorage.alarmActiveChange(id, active);

    return res;
  }

  static Future<void> setNotificationOnAppKillContent(
    String title,
    String body,
  ) =>
      AlarmStorage.setNotificationContentOnAppKill(title, body);

  static bool hasAlarm() => AlarmStorage.hasAlarm();

  static List<AlarmModel> getAlarms() => AlarmStorage.getSavedAlarms();

  static AlarmModel? getAlarmWithId(int alarmId) =>
      AlarmStorage.getAlarm(alarmId);
}
