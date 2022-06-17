class Course {
  int? id;
  String course;

  Course({this.id, required this.course});

  Map<String, dynamic> toMap() => {'id': id, 'course': course};

  static Course fromMap(Map<String, dynamic> json) => Course(
        id: json["id"],
        course: json["course"],
      );

  String toString() => this.course;
}
