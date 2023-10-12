import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final Map<String, dynamic>? notificationData;

  NotificationScreen({Key? key, required this.notificationData, String? title, String? body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Title: ${notificationData?['title'] ?? 'No title'}'),
            Text('Body: ${notificationData?['body'] ?? 'No body'}'),
          ],
        ),
      ),
    );
  }
}
