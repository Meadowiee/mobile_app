import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/auth/views/login_page.dart';

import 'profile/models/profile_model.dart';
import 'profile/views/profile_detail_page.dart';
import 'profile/controllers/profile_controller.dart';
import 'auth/views/register_page.dart';
import 'utils/session_manager.dart';
import 'room-chat/views/room_chat_page.dart';

void main() async {
  Get.put(ProfileController());
  WidgetsFlutterBinding.ensureInitialized();
  bool isLogged = await SessionManager().isLoggedIn();
  runApp(MyApp(isLogged: isLogged));
}

class MyApp extends StatelessWidget {
  final bool isLogged;

  const MyApp({super.key, required this.isLogged});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Brew Chat',
      debugShowCheckedModeBanner: false,
      initialRoute: isLogged ? '/home' : '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/home', page: () =>RoomChatPage ()),
      ],

      theme: ThemeData(
        useMaterial3: true,

        // Colors
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Color(0xFFC9F158), // light lime green color
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),

        // AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
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
          indicatorColor: const Color(0xFFC9F158).withOpacity(0.15),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 14, color: Colors.black),
          ),
          iconTheme: MaterialStateProperty.all(
            const IconThemeData(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
