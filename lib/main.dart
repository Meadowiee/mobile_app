import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'coffee-spot/views/coffee_spot_page.dart';
import 'profile/models/profile_model.dart';
import 'profile/views/profile_detail_page.dart';

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

      theme: ThemeData(
        useMaterial3: true,

        // primaryColor: Color(0xFFF2F3F5),
        // scaffoldBackgroundColor: Color(0xFFF2F3F5),

        // Colors
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Color(0xFFA7F34B), // neon green
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Color(0xFFF2F3F5),
          onSurface: Colors.black,
        ),

        // AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF2F3F5),
          foregroundColor: Colors.black,
        ),

        // Text theme
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
          titleLarge: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Bottom Navigation Bar theme
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(
            0xFFA7F34B,
          ).withOpacity(0.15), // soft green selection
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 14, color: Colors.black),
          ),
          iconTheme: MaterialStateProperty.all(
            const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      home: ProfileDetailPage(
        profile: Profile(
          id: '1',
          name: 'Dummy',
          username: 'Dummy',
          email: 'dummy@example.com',
          password: 'password',
        ),
      ),
    );
  }
}
