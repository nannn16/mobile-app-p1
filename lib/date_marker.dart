import 'package:flutter/material.dart';

/* date marker in the calendar */
class DateMarker extends StatelessWidget {
  DateMarker({required this.date, required this.color});

  final DateTime date;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 40,
      height: 40,
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
