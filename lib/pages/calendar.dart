import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Event {
  final String title;
  Event(this.title);

  Map<String, dynamic> toJson() => {
    'title': title,
  };

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(json['title']);
  }
}

class Planner extends StatefulWidget {
  const Planner({super.key});

  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<DateTime> _highlightedDays = {};
  Map<DateTime, List<Event>> _events = {};
  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? eventsString = prefs.getString('events');
    if (eventsString != null) {
      Map<String, dynamic> eventsMap = json.decode(eventsString);
      setState(() {
        _events = eventsMap.map((dateString, events) {
          DateTime date = DateTime.parse(dateString);
          List<Event> eventList = (events as List)
              .map((eventData) => Event.fromJson(eventData))
              .toList();
          return MapEntry(date, eventList);
        });
      });
    }
  }

  Future<void> _saveEvents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> eventsMap = _events.map((date, events) {
      return MapEntry(
        date.toIso8601String(),
        events.map((event) => event.toJson()).toList(),
      );
    });
    await prefs.setString('events', json.encode(eventsMap));
  }

  void _addEvent() {
    setState(() {
      final eventText = _eventController.text;
      if (eventText.isNotEmpty) {
        final selectedDate = _selectedDay ?? _focusedDay;
        _events[selectedDate] = (_events[selectedDate] ?? [])..add(Event(eventText));
        _highlightedDays.add(selectedDate);
        _eventController.clear();
        _saveEvents();
      }
    });
  }

  void _deleteEvent(DateTime date, Event event) {
    setState(() {
      _events[date]?.remove(event);
      if (_events[date]?.isEmpty ?? true) {
        _events.remove(date);
        _highlightedDays.remove(date);
      }
      _saveEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/spacebackgroundcalendar.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Keep Track of Your Work!', style: TextStyle(fontSize: 35)),
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                    _selectedDay = selectedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent.shade100,
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    // Highlight days that have events
                    if (_events.containsKey(day)) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent, // Change color as needed
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (_selectedDay != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _eventController,
                    decoration: const InputDecoration(
                      labelText: 'Add Event',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addEvent,
                  child: const Text('Add Event'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Events for ${(_selectedDay ?? _focusedDay).toString().substring(0, 10)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...(_events[_selectedDay ?? _focusedDay] ?? []).map((event) => ListTile(
                      title: Text(event.title),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteEvent(_selectedDay ?? _focusedDay, event),
                      ),
                    )),
              ],
              const SizedBox(height: 20),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.grey,
                child: const Text(
                  'Back to Home',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}