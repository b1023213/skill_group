import 'package:flutter/material.dart';

class Memo extends StatelessWidget {
  const Memo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Todo List'),
            SizedBox(height: 20),
            Text('No tasks available'),
          ],
        ),
      ),
    );
  }
}