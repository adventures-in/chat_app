import 'package:cloud_firestore/cloud_firestore.dart';

class FakeDocumentSnapshot implements DocumentSnapshot {
  @override
  dynamic operator [](String key) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  // TODO: implement data
  Map<String, dynamic> get data => <String, dynamic>{
        'authorId': '123',
        'text': 'hellow',
        'timestamp': Timestamp.fromDate(DateTime.parse('1969-07-20 20:18:04'))
      };

  @override
  // TODO: implement documentID
  String get documentID => throw UnimplementedError();

  @override
  // TODO: implement exists
  bool get exists => throw UnimplementedError();

  @override
  // TODO: implement metadata
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  // TODO: implement reference
  DocumentReference get reference => throw UnimplementedError();
}
