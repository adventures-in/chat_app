import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

class FakeQuerySnapshotDatabaseService extends Fake implements  {
  final controller = StreamController<QuerySnapshot>();

  @override
  Stream<QuerySnapshot> get getConversationsStream => controller.stream;

  void add(QuerySnapshot conversation) => controller.add(conversation);

  void close() {
    controller.close();
  }
}
