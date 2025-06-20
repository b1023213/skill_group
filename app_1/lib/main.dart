import 'package:flutter/material.dart';
final col = Column(children: const[
  Text('りんご'),
  Text('みかん'),
  Text('バナナ'),
]);
void main() {
  final a = MaterialApp(
              home:  Scaffold(
                body: Center(
                  child: col,
                ),  
              ),
            );
  runApp(a);
}