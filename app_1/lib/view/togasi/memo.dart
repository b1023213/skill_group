import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; //pubspec.yamlに追加が必要

class Memo extends StatefulWidget {
  //メモ一覧画面
  // このクラスはメモの一覧を表示し、追加、編集、削除を行うための画面
  // メモはSharedPreferencesを使用してローカルに保存される
  const Memo({super.key});

  @override
  State<Memo> createState() => _MemoState();
}

class _MemoState extends State<Memo> {
  // メモの状態を管理するクラス
  List<String> _memos = []; // メモのリスト

  @override
  void initState() {
    // 初期化時にメモをロード
    // SharedPreferencesからメモを読み込み、状態を更新する
    super.initState();
    _loadMemos();
  }

  Future<void> _loadMemos() async {
    final prefs =
        await SharedPreferences.getInstance(); // SharedPreferencesのインスタンスを取得
    // 'memos'キーで保存されたメモのリストを取得し、
    // 取得できなかった場合は空のリストを使用
    // 取得したリストを状態に反映
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
      // 新しいメモを追加するための画面を表示
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
                // メモがない場合の表示
                'メモがありません',
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
  // メモの詳細クラス
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState(); // 初期化処理
    // 初期テキストがあればそれを設定し、なければ空 のテキストフィールドを作成
    _controller = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // メモの詳細画面
    // 入力画面と保存についての処理を行う
    return Scaffold(
      appBar: AppBar(title: const Text('メモ詳細')),
      body: Padding(
        // メモ内容を入力するためのテキストフィールド
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
        // 保存ボタン
        onPressed: () {
          Navigator.pop(context, _controller.text); // 入力されたテキストを戻り値として返す
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
