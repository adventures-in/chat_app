import 'package:flutter/material.dart';

Widget wrapWidget(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}
