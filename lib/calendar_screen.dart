import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_calendar/edit_event_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tuple/tuple.dart';

import 'constant.dart';
import 'sqlite/course.dart';
import 'date_marker.dart';
import 'sqlite/db.dart';
import 'sqlite/event.dart';
import 'event_entry_screen.dart';
import 'page.dart';

class CalendarEventsScreen extends StatefulWidget {
  const CalendarEventsScreen({Key? key}) : super(key: key);

  @override
  State<CalendarEventsScreen> createState() => _CalendarEventsScreenState();
}

class _CalendarEventsScreenState extends State<CalendarEventsScreen> {
  late Map<DateTime, List<Tuple2<Event, Course>>> events;
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  List<Tuple2<Event, Course>> selectedEvents = [];

  @override
  void initState() {
    DateTime sDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime fDate =
        DateTime(focusedDate.year, focusedDate.month, focusedDate.day);
    selectedDate = DateTime.parse(sDate.toString() + 'Z');
    focusedDate = DateTime.parse(fDate.toString() + 'Z');
    events = {};
    DB.instance.initDB().then((value) => fetchEvents());
    super.initState();
  }

  void fetchEvents() async {
    List<Map<String, dynamic>> results = await DB.instance.getAllEvents();
    List<Event> allEvents =
        results.map((event) => Event.fromMap(event)).toList();
    List<Tuple2<Event, Course>> allEventsPair = [];
    for (Event event in allEvents) {
      List<Map<String, dynamic>> courseResult =
          await DB.instance.getCourseById(event.courseId!);
      Course c = Course.fromMap(courseResult[0]);
      allEventsPair.add(Tuple2(event, c));
    }
    setState(() {
      events = {};
      for (var element in allEventsPair) {
        print(element);
        DateTime date = DateTime.parse(element.item1.date);
        if (events.containsKey(date)) {
          events[date]?.add(element);
        } else {
          events[date] = [element];
        }
      }
      selectedEvents = getEventsFromDay(selectedDate);
    });
  }

  List<Tuple2<Event, Course>> getEventsFromDay(DateTime date) {
    return events[date] ?? [];
  }

  void onDaySelected(DateTime tapedDay, DateTime focusDay) {
    if (!isSameDay(selectedDate, tapedDay)) {
      setState(() {
        selectedDate = tapedDay;
        focusedDate = focusDay;
        selectedEvents = getEventsFromDay(selectedDate);
      });
    }
  }

  Future<void> navigateAndGetAddedEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EventScreen()),
    );

    if (result == null) {
    } else {
      await DB.instance.insertEvent(result);
      fetchEvents();
    }
  }

  Future<void> navigateAndGetEditEvent(
      BuildContext context, Event event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditEventScreen(event: event)),
    );

    if (result == null) {
    } else {
      await DB.instance.updateEvent(result);
    }
    fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return MyPage(
      myWidget: Column(children: <Widget>[
        TableCalendar(
          firstDay: DateTime.utc(2000),
          lastDay: DateTime.utc(2040),
          focusedDay: focusedDate,
          calendarFormat: CalendarFormat.month,
          headerStyle: const HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
          ),
          eventLoader: getEventsFromDay,
          onDaySelected: onDaySelected,
          selectedDayPredicate: (day) => isSameDay(day, selectedDate),
          onPageChanged: (day) {
            focusedDate = day;
          },
          calendarBuilders: CalendarBuilders(todayBuilder: (context, date, _) {
            return DateMarker(
              date: date,
              color: Color(0xFFF5AF9D),
            );
          }, selectedBuilder: (context, date, _) {
            return DateMarker(
              date: date,
              color: Color(0xFFEE7658),
            );
          }),
        ),
        Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Schedule',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Mulish',
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  DateFormat('dd MMM yyyy').format(selectedDate),
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Mulish',
                      fontSize: 16),
                ),
              ],
            )),
        Expanded(
          child: ListView(
            children: selectedEvents
                .map((event) => Card(
                        child: ListTile(
                      title: Text(event.item1.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mulish',
                              fontSize: 18)),
                      subtitle: Text('Course: ' + event.item2.toString()),
                      onTap: () =>
                          navigateAndGetEditEvent(context, event.item1),
                    )))
                .toList(),
          ),
        )
      ]),
      myFloatingButton: FloatingActionButton(
        onPressed: () => navigateAndGetAddedEvent(context),
        backgroundColor: kFloatingButtonColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
