import 'package:flutter/material.dart';
import 'package:app_1/view/muramoto/money.dart';
import 'package:app_1/view/hata/todo.dart';
import 'package:app_1/view/odato/niku.dart';
import 'package:app_1/view/togasi/memo.dart';
import 'package:app_1/view/rikiya/nikki.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyApp')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Money()),
                );
              },
              child: const Text('Button 1'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TodoPage()),
                );
              },
              child: const Text('Button 2'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Nikki()),
                );
              },
              child: const Text('Button 2'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Memo()),
                );
              },
              child: const Text('Button 3'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Niku()),
                );
              },
              child: const Text('筋トレ記録'),
            ),
          ],
        ),
      ),
    );
  }
}
