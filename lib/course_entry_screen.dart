import 'package:flutter/material.dart';
import 'sqlite/course.dart';

class CourseEntryScreen extends StatefulWidget {
  const CourseEntryScreen({Key? key}) : super(key: key);

  @override
  State<CourseEntryScreen> createState() => _CourseEntryScreenState();
}

class _CourseEntryScreenState extends State<CourseEntryScreen> {
  String? courseName;

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
          'Add a new course',
          style: TextStyle(color: Colors.black, fontFamily: 'Mulish'),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
                primary: Colors.black,
                textStyle: const TextStyle(fontSize: 20)),
            onPressed: () {
              Course course = Course(course: courseName!);
              Navigator.pop(context, course);
            },
            child: const Text(
              'Add',
            ),
          ),
        ],
        backgroundColor: Color(0xFFffccbc),
      ),
      body: Column(children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: TextField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              fillColor: Colors.black,
              labelText: 'Course Name',
            ),
            onChanged: (String inputTitle) {
              setState(() {
                courseName = inputTitle;
              });
            },
          ),
        ),
      ]),
    );
  }
}
