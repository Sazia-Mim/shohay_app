import 'package:flutter/material.dart';
import 'package:shohay_app/pages/collect_emergency_contact.dart';
import 'package:shohay_app/pages/collect_emergency_contact.dart';
import 'package:shohay_app/pages/sms.dart';
import 'package:shohay_app/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
       theme: ShohayAppTheme.lightTheme,
      home: EmergencyContact(),
    );
  }
}

