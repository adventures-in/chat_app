import 'package:adventures_in_chat_app/widgets/chat_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // set firestore to connect to local emulated firestore
  await Firestore.instance.settings(
    host: 'localhost:8081',
    sslEnabled: false,
    persistenceEnabled: false,
  );

  runApp(ChatApp());
}
