import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:voting/screens/home_page.dart';
import 'package:voting/screens/login.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash_screen',
      getPages: [
        GetPage(name: '/login_screen', page: () => const LoginScreen()),
        GetPage(name: '/', page: () => const HomeScreen()),
      ],
    ),
  );
}