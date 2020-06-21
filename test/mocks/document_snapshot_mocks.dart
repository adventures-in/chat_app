import 'package:cloud_firestore/cloud_firestore.dart';

class FakeDocumentSnapshot implements DocumentSnapshot {
  var _data = <String, dynamic>{};

  FakeDocumentSnapshot.nullData() {
    _data = null;
  }

  FakeDocumentSnapshot.asMessage(
      String authorId, String text, Timestamp timestamp) {
    _data = <String, dynamic>{};
    _data.addAll(<String, dynamic>{
      'authorId': authorId,
      'text': text,
      'timestamp': timestamp
    });
  }

  FakeDocumentSnapshot.asUserItem(String displayName, dynamic photoURL) {
    _data = <String, dynamic>{};
    _data.addAll(<String, dynamic>{
      'documentID': documentID,
      'displayName': displayName,
      'photoURL': photoURL
    });
  }

  @override
  dynamic operator [](String key) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> get data => _data;

  @override
  // TODO: implement documentID
  String get documentID => 'abc123';

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
