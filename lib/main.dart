import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationApp(),
    );
  }
}

class NotificationApp extends StatefulWidget {
  const NotificationApp({Key? key}) : super(key: key);

  @override
  NotificationAppState createState() => NotificationAppState();
}

class NotificationAppState extends State<NotificationApp> {
  //notification object
  late FlutterLocalNotificationsPlugin localNotifications;

  //инициализация
  @override
  void initState() {
    super.initState();
    //object for Android settings
    var androidInitialize = const AndroidInitializationSettings('ic_launcher');
    //объект для IOS настроек
    var iOSInitialize = const IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    // general initialization
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    //create local notification
    localNotifications = FlutterLocalNotificationsPlugin();
    // initialize local notification
    localNotifications.initialize(initializationSettings);
    // initialize time zone
    tz.initializeTimeZones();
  }

  //one-time notification function
  Future _oneTimeNotification() async {
    var androidDetails = const AndroidNotificationDetails(
      "01",
      "One-time notification",
      importance: Importance.high,
      channelDescription: "Контент уведомления",
    );
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotifications.show(
      01,
      "One-time notification",
      "Read me",
      generalNotificationDetails,
    );
  }

  //every minute notification function
  Future<void> _minuteNotifications() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('02', 'Every minute notification',
            importance: Importance.high, playSound: true);
    const IOSNotificationDetails iosDetails = IOSNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotifications.periodicallyShow(
        02,
        'Every minute notification',
        "Don't forget about me!",
        RepeatInterval.everyMinute,
        platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }

  //every day notification function
  Future<void> _everydayNotifications() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('03', 'Every day notification',
            importance: Importance.high, playSound: true);
    const IOSNotificationDetails iosDetails = IOSNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotifications.periodicallyShow(03, 'Every day notification',
        'See you tomorrow!', RepeatInterval.daily, platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }

  //function to cancel all notifications
  Future<void> _cancelAllNotifications() async {
    await localNotifications.cancelAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.yellow.shade500),
                  fixedSize: MaterialStateProperty.all(const Size(200, 50)),
                  shadowColor: MaterialStateProperty.all(Colors.grey),
                ),
                onPressed: _oneTimeNotification,
                child: const Text(
                  "One-Time notification",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.yellow.shade300),
                  fixedSize: MaterialStateProperty.all(const Size(200, 50)),
                  shadowColor: MaterialStateProperty.all(Colors.grey),
                ),
                onPressed: _minuteNotifications,
                child: const Text(
                  "Every minute notification",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.yellow.shade100),
                  fixedSize: MaterialStateProperty.all(const Size(200, 50)),
                  shadowColor: MaterialStateProperty.all(Colors.grey),
                ),
                onPressed: _everydayNotifications,
                child: const Text(
                  "Every day notification",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.red.shade400),
                  fixedSize: MaterialStateProperty.all(const Size(200, 50)),
                  shadowColor: MaterialStateProperty.all(Colors.grey),
                ),
                onPressed: _cancelAllNotifications,
                child: const Text(
                  "Cancel all notifications",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ))
          ],
        ),
      ),
    );
  }
}
