import 'package:bmbuffet/test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom.dart';
import 'drink screen.dart';
import 'juice/updatedata.dart';
import 'onboarding screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
//print("Handling a background message: ${message.messageId}");
//}

void main() async {


//  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print(fcmToken);
  // Request permission for notification
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //  print('Got a message whilst in the foreground!');
    //  print('Message data: ${message.data}');

    //  if (message.notification != null) {
    //   print('Message also contained a notification:');
    //    if (message.notification?.title != null) {
  //   print('Title: ${message.notification?.title}');
  //   }
//   if (message.notification?.body != null) {
  //   print('Body: ${message.notification?.body}');
  //   }

  // }
  // });

  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  //NotificationSettings settings = await messaging.requestPermission();
  //if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  // print('User granted permission');
    //} else {
  //  print('User declined or has not granted permission');
  // }

  // Handle background message
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Handle foreground message
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  // print('Got a foreground message: ${message.messageId}');
  //  FirebaseMessaging messaging = FirebaseMessaging.instance;

// Set up listener for foreground messages
  //FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //  print('Got a message whilst in the foreground!');
      // print('Message data: ${message.data}');

  // if (message.notification != null) {
  //    print('Message also contained a notification: ${message.notification}');
  //   }
// });
  // });

  // Handle message opened
  //FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  // print('Message opened with payload: ${message.data}');
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Navigate to the desired screen in your app or perform other necessary actions
  //  print('A new onMessageOpenedApp event was published!');
  //  print('Message data: ${message.data}');
  //   print('Message notification: ${message.notification}');
  //  });
  // });

  runApp(MyApp());
}


class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasDeliveryData = false;

  @override
  void initState() {
    super.initState();
    _checkDeliveryData();
  }

  void _checkDeliveryData() async {
    final prefs = await SharedPreferences.getInstance();
    final hasName = prefs.getString('name') != null && prefs.getString('name')!.isNotEmpty;

    setState(() {
      _hasDeliveryData = hasName ;
    });
  }

  void _setDeliveryData(bool hasData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasDeliveryData', hasData);
    print('Saved hasDeliveryData: $hasData');

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      color: Colors.white,
     home: BuffetLocationScreen(),
     // home: _hasDeliveryData ? BuffetLocationScreen() : DeliveryDataScreen(onSave: () {
      // _setDeliveryData(true);
        //  _checkDeliveryData(); // Update _hasDeliveryData after saving delivery data
      //  Navigator.pushReplacement(
        //    context,
      //   MaterialPageRoute(builder: (context) => BuffetLocationScreen()),
        //   );
      //  }),
    );
  }
}
