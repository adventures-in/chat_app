import 'package:adventures_in_chat_app/widgets/chat_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() async {
  enableFlutterDriverExtension();

  /// The [Firebase] plugin seems to require binding is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChatApp());
}
