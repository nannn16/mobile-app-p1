class Event {
  int? id;
  String title;
  String date;
  int? courseId;

  Event({this.id, required this.title, required this.date, this.courseId});

  Map<String, dynamic> toMap() =>
      {'id': id, 'title': title, 'date': date, 'courseId': courseId};

  static Event fromMap(Map<String, dynamic> json) => Event(
        id: json["id"],
        title: json["title"],
        date: json["date"],
        courseId: json["courseId"],
      );

  String toString() => this.title;
}
