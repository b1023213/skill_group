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
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    // ホーム画面
    Center(child: Text('ホーム画面', style: TextStyle(fontSize: 24))),
    Money(),
    TodoPage(),
    Nikki(),
    Memo(),
    Niku(),
  ];

  static const List<String> _titles = ['ホーム', '家計簿', 'ToDo', '日記', 'メモ', '肉'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('技術班練習 - ${_titles[_selectedIndex]}')),
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: '家計簿'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'ToDo'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: '日記'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'メモ'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: '肉'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
