import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Map<String, String>>> _events = {};
  bool _repeatWeekly = false; // チェックボックスの状態保持

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _addEvent(String title, String? time) {
    final key = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
    );
    if (_events[key] == null) {
      _events[key] = [];
    }
    _events[key]!.add({'title': title, 'time': time ?? ''});
    setState(() {});
  }

  void _addEventToSameWeekdays(String title, String? time) {
    if (_selectedDay == null) return;

    final year = _selectedDay!.year;
    final month = _selectedDay!.month;
    final weekday = _selectedDay!.weekday;

    DateTime current = DateTime(year, month, 1);
    while (current.month == month) {
      if (current.weekday == weekday) {
        final key = DateTime(current.year, current.month, current.day);
        if (_events[key] == null) {
          _events[key] = [];
        }
        _events[key]!.add({'title': title, 'time': time ?? ''});
      }
      current = current.add(const Duration(days: 1));
    }

    setState(() {});
  }

  void _removeEvent(int index) {
    final key = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
    );
    _events[key]!.removeAt(index);
    if (_events[key]!.isEmpty) {
      _events.remove(key);
    }
    setState(() {});
  }

  void _showAddEventDialog() {
    String eventText = '';
    String eventTime = '';
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('イベントを追加'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    onChanged: (value) => eventText = value,
                    decoration: const InputDecoration(hintText: 'やること'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'やることを入力してね';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onChanged: (value) => eventTime = value,
                    decoration: const InputDecoration(
                      hintText: '時間（例: 14:00）※任意',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
                      if (!regex.hasMatch(value)) {
                        return '時間は 00:00 形式で入力してね';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _repeatWeekly,
                        onChanged: (value) {
                          setStateDialog(() {
                            _repeatWeekly = value ?? false;
                          });
                        },
                      ),
                      const Text('この月の毎週同じ曜日に追加'),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _repeatWeekly = false;
                  Navigator.pop(context);
                },
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_repeatWeekly) {
                      _addEventToSameWeekdays(eventText, eventTime);
                    } else {
                      _addEvent(eventText, eventTime);
                    }
                    _repeatWeekly = false;
                    Navigator.pop(context);
                  }
                },
                child: const Text('追加'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ToDo Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _selectedDay == null ? null : _showAddEventDialog,
            child: const Text('イベント追加'),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text('日付を選択してね'))
                : Builder(
                    builder: (context) {
                      final events = _getEventsForDay(_selectedDay!);

                      // ソート: 時間なし→上、時間あり→時間順
                      events.sort((a, b) {
                        final aTime = a['time'] ?? '';
                        final bTime = b['time'] ?? '';

                        if (aTime.isEmpty && bTime.isNotEmpty) return -1;
                        if (aTime.isNotEmpty && bTime.isEmpty) return 1;
                        if (aTime.isEmpty && bTime.isEmpty) return 0;
                        return aTime.compareTo(bTime);
                      });

                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          final title = event['title'] ?? '';
                          final time = event['time'];
                          return ListTile(
                            title: Text(
                              time != null && time.isNotEmpty
                                  ? '[$time] $title'
                                  : title,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeEvent(index),
                            ),
                            onTap: () {
                              _showEditEventDialog(index, event);
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showEditEventDialog(int index, Map<String, String> event) {
    String editedTitle = event['title'] ?? '';
    String editedTime = event['time'] ?? '';

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('イベントを編集'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: editedTitle,
                onChanged: (value) => editedTitle = value,
                decoration: const InputDecoration(hintText: 'やること'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'やることを入力してね';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: editedTime,
                onChanged: (value) => editedTime = value,
                decoration: const InputDecoration(hintText: '時間（例: 14:00）※任意'),
                validator: (value) {
                  if (value == null || value.isEmpty) return null;
                  final regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
                  if (!regex.hasMatch(value)) {
                    return '時間は 00:00 形式で入力してね';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final key = DateTime(
                  _selectedDay!.year,
                  _selectedDay!.month,
                  _selectedDay!.day,
                );
                setState(() {
                  _events[key]![index] = {
                    'title': editedTitle,
                    'time': editedTime,
                  };
                });
                Navigator.pop(context);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
