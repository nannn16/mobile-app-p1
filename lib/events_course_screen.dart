import 'package:flutter/material.dart';
import 'package:project_calendar/constant.dart';
import 'sqlite/event.dart';
import 'package:intl/intl.dart';
import 'constant.dart';

class EventsOfCourse extends StatelessWidget {
  const EventsOfCourse({required this.events, required this.courseName});

  final List<Event> events;
  final String courseName;

  /* display all events of the selected course */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          courseName,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: kBackgroundColor,
      ),
      body: ListView(
          children: events
              .map((event) => Card(
                      child: ListTile(
                    title: Text(event.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Mulish',
                            fontSize: 18)),
                    subtitle: Text(DateFormat('EEEE, dd MMM yyyy')
                        .format(DateTime.parse(event.date))),
                  )))
              .toList()),
    );
  }
}
