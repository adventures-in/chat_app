import 'package:cloud_firestore/cloud_firestore.dart';

class FakeDocumentSnapshot implements DocumentSnapshot {
  final String authorId;
  final String text;
  final Timestamp timestamp;

  FakeDocumentSnapshot(this.authorId, this.text, this.timestamp);

  @override
  dynamic operator [](String key) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  // TODO: implement data
  Map<String, dynamic> get data => <String, dynamic>{
        'authorId': authorId,
        'text': text,
        'timestamp': timestamp
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
