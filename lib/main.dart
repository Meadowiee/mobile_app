import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Brew Chat',
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}
