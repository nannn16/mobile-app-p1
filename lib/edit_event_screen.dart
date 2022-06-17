import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_calendar/constant.dart';
import 'package:project_calendar/sqlite/event.dart';
import 'sqlite/db.dart';
import 'sqlite/course.dart';

/* edit and delete event page */
class EditEventScreen extends StatefulWidget {
  final Event event;

  const EditEventScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  DateTime? dateTime;
  String? title;
  String courseName = '';
  List<Course> coursesList = [];
  final TextEditingController _titleController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.parse(widget.event.date);
    title = widget.event.title;
    _titleController.text = title!;
    if (widget.event.courseId != null) {
      getCourseName(widget.event.courseId!);
    }
    getCourses();
  }

  void getCourseName(int id) async {
    List<Map<String, dynamic>> results = await DB.instance.getCourseById(id);
    Course c = Course.fromMap(results[0]);
    setState(() {
      courseName = c.course;
    });
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
            'Edit an event',
            style: TextStyle(color: Colors.black, fontFamily: 'Mulish'),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.black,
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
                Event event = Event(
                    id: widget.event.id,
                    title: title!,
                    date: dateTime!.toIso8601String(),
                    courseId: widget.event.courseId);
                Navigator.pop(context, event);
              },
              child: const Text(
                'Save',
              ),
            ),
          ],
          backgroundColor: kBackgroundColor2,
        ),
        body: Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _titleController,
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
                    DateFormat('EEEE, dd MMM yyyy').format(dateTime!),
                  ),
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: dateTime!,
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2040))
                        .then((date) {
                      setState(() {
                        DateTime getDate = date!;
                        dateTime =
                            DateTime(getDate.year, getDate.month, getDate.day);
                        dateTime = DateTime.parse(dateTime.toString() + 'Z');
                      });
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: <Widget>[
                Text('Course:'),
                SizedBox(width: 10),
                Text(courseName),
              ],
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
                primary: Colors.red, textStyle: const TextStyle(fontSize: 20)),
            onPressed: () {
              DB.instance.deleteEvent(widget.event);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete Event',
            ),
          ),
        ]));
  }
}
