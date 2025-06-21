import 'package:flutter/material.dart';

class Nikki extends StatelessWidget {
  const Nikki({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(title: const Text('Todo')),
=======
      appBar: AppBar(
        title: const Text('Todo'),
      ),
>>>>>>> 2e881ab1d5993855dc8820b1c3eeabd389ff59c7
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
<<<<<<< HEAD
}
=======
}
>>>>>>> 2e881ab1d5993855dc8820b1c3eeabd389ff59c7
