import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'constant.dart';
import 'sqlite/course.dart';
import 'course_entry_screen.dart';
import 'sqlite/db.dart';
import 'sqlite/event.dart';
import 'events_course_screen.dart';
import 'page.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late List<Course> classes;
  late Map<String, List<Event>> classesMap;
  List<Event> selectedCourses = [];

  void fetchCourses() async {
    List<Map<String, dynamic>> coursesResults =
        await DB.instance.getAllCourses();
    List<Course> allCourses =
        coursesResults.map((course) => Course.fromMap(course)).toList();
    List<Map<String, dynamic>> eventsResults = await DB.instance.getAllEvents();
    List<Event> allEvents =
        eventsResults.map((event) => Event.fromMap(event)).toList();
    List<Tuple2<Event, Course>> allEventsPair = [];
    for (Event event in allEvents) {
      List<Map<String, dynamic>> courseResult =
          await DB.instance.getCourseById(event.courseId!);
      Course c = Course.fromMap(courseResult[0]);
      allEventsPair.add(Tuple2(event, c));
    }
    setState(() {
      classes = [];
      classes = allCourses;
      classesMap = {};
      for (Tuple2 pair in allEventsPair) {
        if (classesMap.containsKey(pair.item2.toString())) {
          classesMap[pair.item2.toString()]?.add(pair.item1);
        } else {
          classesMap[pair.item2.toString()] = [pair.item1];
        }
      }
    });
  }

  @override
  void initState() {
    classes = [];
    classesMap = {};
    DB.instance.initDB().then((value) => fetchCourses());
    super.initState();
  }

  Future<void> navigateAndGetAddedEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CourseEntryScreen()),
    );

    if (result == null) {
    } else {
      DB.instance.insertCourse(result);
      fetchCourses();
    }
  }

  void deleteCourse(Course course) async {
    await DB.instance.deleteCourse(course);
    fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return MyPage(
      myWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Courses',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Mulish',
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView(
              children: classes
                  .map((subject) => Card(
                        child: ListTile(
                          title: Text(subject.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Mulish',
                                  fontSize: 18)),
                          onTap: () {
                            setState(() {
                              selectedCourses =
                                  classesMap[subject.toString()] ?? [];
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventsOfCourse(
                                          selectedCourses: selectedCourses,
                                          courseName: subject.toString(),
                                        )));
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => deleteCourse(subject),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
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
