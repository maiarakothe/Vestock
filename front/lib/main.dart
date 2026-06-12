import 'package:flutter/material.dart';
import 'package:front/pages/home_screen.dart';
import 'package:front/pages/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vestock',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}