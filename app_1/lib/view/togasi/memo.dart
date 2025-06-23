import 'package:flutter/material.dart';

class Memo extends StatelessWidget {
  const Memo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('This is the Memo page'),
            SizedBox(height: 20),
            Text('No memos available'),
          ],
        ),
      ),
    );
  }
}
