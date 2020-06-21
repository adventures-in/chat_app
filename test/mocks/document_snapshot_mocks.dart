import 'package:cloud_firestore/cloud_firestore.dart';

class FakeMessageDocumentSnapshot implements DocumentSnapshot {
  final String authorId;
  final String text;
  final Timestamp timestamp;

  FakeMessageDocumentSnapshot(this.authorId, this.text, this.timestamp);

  @override
  dynamic operator [](String key) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
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

class FakeUserItemDocumentSnapshot implements DocumentSnapshot {
  var _data = <String, dynamic>{};

  FakeUserItemDocumentSnapshot(String displayName, dynamic photoURL) {
    _data = <String, dynamic>{};
    _data.addAll(<String, dynamic>{
      'documentID': documentID,
      'displayName': displayName,
      'photoURL': photoURL
    });
  }

  FakeUserItemDocumentSnapshot.nullData() {
    _data = null;
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
