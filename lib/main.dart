import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:voting/screens/home_page.dart';
import 'package:voting/screens/votes_added.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomePage(),
        'votes_added': (context) => VotesAdded(),
      },
    ),
  );
}
