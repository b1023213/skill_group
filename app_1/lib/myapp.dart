import 'package:flutter/material.dart';

import 'package:app_1/view/hata/todo.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyApp'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OdatoPage()),
                );
              },
              child: const Text('Button 1'),
            ),
            ElevatedButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TodoPage()),
                );
                }, child: const Text('Button 2')
          ),
            ElevatedButton(
              onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OdatoPage()),
                );
            }, child: const Text('Button 2')),
            ElevatedButton(
              onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OdatoPage()),
                );
            }, child: const Text('Button 3')),
            ElevatedButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OdatoPage()),
                );
            }, child: const Text('Button 4')),
            ElevatedButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OdatoPage()),
                );
            }, child: const Text('Button 5')),
            ElevatedButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OdatoPage()),
                );
            }, child: const Text('Button 6')),
            ElevatedButton(onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OdatoPage()),
                );  
            }, child: const Text('Button 7')),
          ],
        ),
      ),
    );
  }
}