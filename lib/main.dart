import 'package:adventures_in_chat_app/widgets/chat_app.dart';
import 'package:flutter/material.dart';

void main() {
  /// The [Firebase] plugin seems to require binding is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChatApp());
}
