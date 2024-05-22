import 'package:device_preview_minus/device_preview_minus.dart';
import 'package:flutter/material.dart';
import 'firstScreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
    );
  }
}
