
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:ffi';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show File, Platform;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';


class NotificationPlugin {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification> didReceivedLocalNotificationSubject =
  BehaviorSubject<ReceivedNotification>();
  var  initializeSettings;

  NotificationPlugin._() {
    init();
  }
  init() async{
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if(Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }
  initializePlatformSpecifics(){
    var initializeSettingsAndroid = AndroidInitializationSettings('app_notf_icon');
    var initializeSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(id: id, title: title, body: body, payload: payload);
        didReceivedLocalNotificationSubject.add(receivedNotification);

      },
    );
    initializeSettings = InitializationSettings(android: initializeSettingsAndroid, iOS: initializeSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializeSettings);
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializeSettings,onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }


  setListenerForLowerVersions(Function onNotificationInLowerVersions){
    didReceivedLocalNotificationSubject.listen((receivedNotification){
      onNotificationInLowerVersions(receivedNotification);
    });
  }
  _requestIOSPermission(){
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  Future<void> showNotification() async {
    var androidChannelSpecifics = AndroidNotificationDetails('CHANNEL_ID','CHANNEL_NAME',
        'CHANNEL_DESCRIPTION');
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Test Title', 'Test Body ', platformChannelSpecifics,payload: 'Test Payload');
  }
}
NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification{
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

