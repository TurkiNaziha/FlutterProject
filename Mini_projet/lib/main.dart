import 'package:flutter/material.dart';
import 'package:mini_projet/pages/app_state.dart';
import 'package:mini_projet/pages/home.page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon'); // Ajoutez une icône dans android/app/src/main/res/drawable
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void showNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails('quiz_channel', 'Quiz Notifications',
      importance: Importance.max, priority: Priority.high);
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0, title, body, platformChannelSpecifics,
  );
}
void main() {
  initializeNotifications();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return MaterialApp(
      home: HomePage(),
      theme: appState.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      themeMode: ThemeMode.system, // Géré par AppState
    );
  }
}