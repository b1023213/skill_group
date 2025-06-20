import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Money extends StatefulWidget {
  const Money({Key? key}) : super(key: key);

  @override
  State<Money> createState() => _MoneyState();
}

class _MoneyState extends State<Money> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, int> _expenses = {
    DateTime.utc(2025, 6, 20): 1200,
    DateTime.utc(2025, 6, 21): 800,
    DateTime.utc(2025, 6, 22): 1500,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('家計簿カレンダー')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                int? amount =
                    _expenses[DateTime.utc(day.year, day.month, day.day)];
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${day.day}'),
                      if (amount != null)
                        Text(
                          '¥$amount',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '選択日: ${_selectedDay!.toLocal()} の利用金額: ¥${_expenses[DateTime.utc(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)] ?? 0}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
