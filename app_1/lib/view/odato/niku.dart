import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Niku extends StatefulWidget {
  const Niku({super.key});

  @override
  State<Niku> createState() => _NikuState();
}

class _NikuState extends State<Niku> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height: 20),
          Text(
            _selectedDay != null
                ? '${_selectedDay!.toLocal()} の記録はまだありません'
                : '日付を選んでください',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
