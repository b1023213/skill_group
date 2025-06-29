import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Memo extends StatefulWidget {
  const Memo({super.key});

  @override
  State<Memo> createState() => _MemoState();
}

class _MemoState extends State<Memo> {
  List<String> _memos = [];

  @override
  void initState() {
    super.initState();
    _loadMemos();
  }

  Future<void> _loadMemos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _memos = prefs.getStringList('memos') ?? [];
    });
  }

  Future<void> _saveMemos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('memos', _memos);
  }

  Future<void> _addMemo() async {
    final newMemo = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MemoDetailPage()),
    );
    if (newMemo != null && newMemo is String && newMemo.isNotEmpty) {
      setState(() {
        _memos.add(newMemo);
      });
      await _saveMemos();
    }
  }

  Future<void> _editMemo(int index) async {
    final updatedMemo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoDetailPage(initialText: _memos[index]),
      ),
    );
    if (updatedMemo != null &&
        updatedMemo is String &&
        updatedMemo.isNotEmpty) {
      setState(() {
        _memos[index] = updatedMemo;
      });
      await _saveMemos();
    }
  }

  Future<void> _deleteMemo(int index) async {
    setState(() {
      _memos.removeAt(index);
    });
    await _saveMemos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memo')),
      body: _memos.isEmpty
          ? const Center(
              child: Text(
                'No memos available',
                style: TextStyle(color: Colors.blue),
              ),
            )
          : ListView.builder(
              itemCount: _memos.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  _memos[index],
                  style: const TextStyle(color: Colors.blue),
                ),
                onTap: () => _editMemo(index),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteMemo(index),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMemo,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MemoDetailPage extends StatefulWidget {
  final String? initialText;
  const MemoDetailPage({this.initialText, super.key});

  @override
  State<MemoDetailPage> createState() => _MemoDetailPageState();
}

class _MemoDetailPageState extends State<MemoDetailPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('メモ詳細')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          maxLines: null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'メモ内容',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _controller.text);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
