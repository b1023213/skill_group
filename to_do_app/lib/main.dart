import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('こんにちはFlutter')),
        body: const Center(
          child: Text('これは簡単なFlutterアプリです！', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}
