import 'package:flutter/material.dart';

import 'constant.dart';

class MyPage extends StatelessWidget {
  final Widget myWidget;
  final FloatingActionButton myFloatingButton;
  const MyPage({required this.myWidget, required this.myFloatingButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: kBackgroundColor,
      ),
      body: myWidget,
      floatingActionButton: myFloatingButton,
    );
  }
}
