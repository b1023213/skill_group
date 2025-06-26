import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class Niku extends StatefulWidget {
  const Niku({super.key});

  @override
  State<Niku> createState() => _NikuState();
}

class _NikuState extends State<Niku> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<String>> _workoutRecords = {};

  int _selectedSets = 1;
  int _selectedReps = 1;
  int _selectedWeight = 1;

  List<String> _getWorkoutsForDay(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    return _workoutRecords[normalizedDay] ?? [];
  }

  void _showAddWorkoutDialog() {
    if (_selectedDay == null) return;

    _selectedSets = 1;
    _selectedReps = 1;
    _selectedWeight = 1;

    TextEditingController workoutNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '${_selectedDay!.toLocal().toIso8601String().split('T')[0]}の記録を追加',
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: workoutNameController,
                      decoration: const InputDecoration(
                        hintText: '種目名 (例: ベンチプレス)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('重量: '),
                        DropdownButton<int>(
                          value: _selectedWeight,
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedWeight = newValue!;
                            });
                          },
                          items: List.generate(200, (index) => index + 1)
                              .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value kg'),
                                );
                              })
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('回数: '),
                        DropdownButton<int>(
                          value: _selectedReps,
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedReps = newValue!;
                            });
                          },
                          items: List.generate(20, (index) => index + 1)
                              .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value 回'),
                                );
                              })
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('セット数: '),
                        DropdownButton<int>(
                          value: _selectedSets,
                          onChanged: (int? newValue) {
                            setState(() {
                              _selectedSets = newValue!;
                            });
                          },
                          items: List.generate(10, (index) => index + 1)
                              .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text('$value セット'),
                                );
                              })
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () {
                if (workoutNameController.text.isNotEmpty) {
                  final String recordText =
                      '${workoutNameController.text} ${_selectedWeight}kg ${_selectedReps}回 ${_selectedSets}セット';
                  setState(() {
                    final normalizedSelectedDay = DateTime.utc(
                      _selectedDay!.year,
                      _selectedDay!.month,
                      _selectedDay!.day,
                    );
                    _workoutRecords
                        .putIfAbsent(normalizedSelectedDay, () => [])
                        .add(recordText);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('追加'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ja_JP', null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('筋トレ記録')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getWorkoutsForDay,
            calendarStyle: const CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            locale: 'ja_JP',
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                const redStyle = TextStyle(color: Colors.red);
                const blueStyle = TextStyle(color: Colors.blue);
                final weekday = day.weekday;
                final label = ['月', '火', '水', '木', '金', '土', '日'][weekday - 1];
                final color = weekday == DateTime.saturday
                    ? blueStyle
                    : redStyle;
                return Center(child: Text(label, style: color));
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _selectedDay != null
                ? Column(
                    children: [
                      Text(
                        '${_selectedDay!.toLocal().toIso8601String().split('T')[0]}の記録:',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_getWorkoutsForDay(_selectedDay!).isEmpty)
                        const Text(
                          'この日の記録はまだありません。',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: _getWorkoutsForDay(_selectedDay!).length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    _getWorkoutsForDay(_selectedDay!)[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _showAddWorkoutDialog,
                        child: const Text('筋トレ記録を追加'),
                      ),
                    ],
                  )
                : const Center(
                    child: Text('日付を選んでください', style: TextStyle(fontSize: 16)),
                  ),
          ),
        ],
      ),
    );
  }
}
