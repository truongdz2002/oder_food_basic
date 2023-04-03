
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class RequestPermissionDevice {
  RequestPermissionDevice();

  final FlutterLocalNotificationsPlugin _notificationLocal = FlutterLocalNotificationsPlugin();

  Future<void> Intialize() async {
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher');
    IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings setting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,);
    await _notificationLocal.initialize(
        setting, onSelectNotification: OnSelectNotification);
  }


  void OnSelectNotification(String? payload) {
    if (payload != null) {
      print('${payload}');
    }
  }

  void onDidReceiveLocalNotification(int id, String? title, String? body,
      String? payload) {
    if (title != null && body != null) {
      print('id:${id.toString()}');
    }
  }

  Future<NotificationDetails> _NotificationDetail(String message,String title) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'channel_id', 'channel_name',
        channelDescription: 'description',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        playSound: true,
        groupKey: '1',
        subText:'Đặt hàng ',
        styleInformation: BigTextStyleInformation(
          message,
        contentTitle: title,
        htmlFormatContentTitle: true,
        htmlFormatBigText: true,
      ),
    );
    const IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    return NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  Future<void> ShowNotification(
      {required id, required String title, required String body}) async {
    final detail = await _NotificationDetail(body,title);
    final detailgroup = await groupNotifications() ;
    await _notificationLocal.show(0, '', '', detailgroup);
    await _notificationLocal.show(id, title, body, detail);

  }

  Future<NotificationDetails> groupNotifications() async {
   InboxStyleInformation inboxStyleInformation=const InboxStyleInformation([],contentTitle: '',summaryText:'Đặt hàng' );
      AndroidNotificationDetails groupNotificationDetails = AndroidNotificationDetails(
        'channel_id', 'channel_name',
        channelDescription: 'description',
        styleInformation:inboxStyleInformation,
        playSound: false,
        setAsGroupSummary: true,
        groupKey: '1',
        showWhen: true
        // onlyAlertOnce: true,
      );
   return NotificationDetails(android: groupNotificationDetails);
    }
  }
