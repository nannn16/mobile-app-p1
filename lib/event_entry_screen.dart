import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_calendar/constant.dart';
import 'package:project_calendar/sqlite/event.dart';
import 'sqlite/course.dart';
import 'sqlite/db.dart';

/* create a new event page */
class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  DateTime dateTime = DateTime.now();
  String? title;
  Course? selectedCourse;
  List<Course> coursesList = [];

  @override
  void initState() {
    super.initState();
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    dateTime = DateTime.parse(dateTime.toString() + 'Z');
    getCourses();
  }

  void getCourses() async {
    List<Map<String, dynamic>> results = await DB.instance.getAllCourses();
    List<Course> allCourses =
        results.map((course) => Course.fromMap(course)).toList();
    setState(() {
      coursesList = allCourses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // cancel button on the left
          leading: IconButton(
            icon: const Icon(
              Icons.cancel,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Create a new event',
            style: TextStyle(color: Colors.black, fontFamily: 'Mulish'),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.black,
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
                if (selectedCourse != null) {
                  Event event = Event(
                      title: title!,
                      date: dateTime.toIso8601String(),
                      courseId: selectedCourse?.id);
                  Navigator.pop(context, event);
                } else {
                  Event event =
                      Event(title: title!, date: dateTime.toIso8601String());
                  Navigator.pop(context, event);
                }
              },
              child: const Text(
                'Add',
              ),
            ),
          ],
          backgroundColor: kBackgroundColor2,
        ),
        body: Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                fillColor: Colors.black,
                labelText: 'Title',
              ),
              onChanged: (String inputTitle) {
                setState(() {
                  title = inputTitle;
                });
              },
            ),
          ),
          // to select the date
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.access_time_outlined,
                    color: Colors.black54,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.black,
                        textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'Mulish')),
                    child: Text(
                      DateFormat('EEEE, dd MMM yyyy').format(dateTime),
                    ),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: dateTime,
                              firstDate: DateTime(2001),
                              lastDate: DateTime(2040))
                          .then((date) {
                        setState(() {
                          DateTime getDate = date!;
                          dateTime = DateTime(
                              getDate.year, getDate.month, getDate.day);
                          dateTime = DateTime.parse(
                              dateTime.toString() + 'Z'); // format the date
                        });
                      });
                    },
                  ),
                ],
              )),
          // dropdown button where user can select courses.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: <Widget>[
                Text('Course'),
                SizedBox(width: 10),
                DropdownButton<Course>(
                  hint: Text("Select Course"),
                  elevation: 16,
                  icon: const Icon(Icons.arrow_downward),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  value: selectedCourse,
                  items: coursesList.map((course) {
                    return DropdownMenuItem<Course>(
                      child: Text(course.toString()),
                      value: course,
                    );
                  }).toList(),
                  onChanged: (selected) {
                    setState(() {
                      selectedCourse = selected;
                    });
                  },
                )
              ],
            ),
          ),
        ]));
  }
}
