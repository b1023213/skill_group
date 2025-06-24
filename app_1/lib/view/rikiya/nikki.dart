import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Nikki extends StatefulWidget {
  const Nikki({super.key});

  @override
  State<Nikki> createState() => _NikkiState();
}

class _NikkiState extends State<Nikki> {
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, String> _memoMap = {};
  final TextEditingController _controller = TextEditingController();

  // 記録保存
  void _saveMemo() {
    setState(() {
      _memoMap[_selectedDate] = _controller.text;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('記録を保存しました')));
  }

  // カレンダーで記録がある日に色を付ける
  bool _hasMemo(DateTime day) {
    return _memoMap.keys.any(
      (d) => isSameDay(d, day) && (_memoMap[d]?.isNotEmpty ?? false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      // カレンダーのタブ
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 記録内容（高さを固定 or Flexibleでラップ）
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 16.0,
              bottom: 8.0,
            ),
            child: Row(
              children: [
                // 左半分に記録内容
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5 - 16,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Text(
                      _memoMap[_selectedDate]?.isNotEmpty == true
                          ? '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日 の記録: ${_memoMap[_selectedDate]}'
                          : '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日 の記録はありません',
                      style: const TextStyle(fontSize: 20),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      maxLines: 5, // ← ここで高さを制限
                    ),
                  ),
                ),
                // 右半分は空白
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          // カレンダー本体を常に下に固定
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 1, 1),
                lastDay: DateTime.utc(2030, 1, 1),
                focusedDay: _selectedDate,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                availableGestures: AvailableGestures.horizontalSwipe,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _controller.text = _memoMap[selectedDay] ?? '';
                  });
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final hasMemo = _hasMemo(day);
                    return Container(
                      decoration: hasMemo
                          ? BoxDecoration(
                              color: Colors.yellow[200],
                              shape: BoxShape.circle,
                            )
                          : null,
                      alignment: Alignment.center,
                      child: Text('${day.day}'),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    final hasMemo = _hasMemo(day);
                    return Container(
                      decoration: BoxDecoration(
                        color: hasMemo ? Colors.orange : Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text('${day.day}'),
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return Container(
                      color: Colors.blue,
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      // 記録するタブ
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(2030, 1, 1),
              focusedDay: _selectedDate,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _controller.text = _memoMap[selectedDay] ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日 の記録',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'この日にちの記録を入力してください',
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _saveMemo, child: const Text('記録')),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('毎日の記録')),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'カレンダー',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: '記録する'),
        ],
      ),
    );
  }
}
