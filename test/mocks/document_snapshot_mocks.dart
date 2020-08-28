import 'package:cloud_firestore/cloud_firestore.dart';

/// The [_data] member is used in the override of the [DocumentSnapshot.data] getter.
///
/// For convenience, named constructors [forMessage] and [forUserItem] create
/// [FakeDocumentSnapshot] objects with the relevant members set for conversion
/// to their respective types ([Message] and [UserItem]).
class FakeDocumentSnapshot implements DocumentSnapshot {
  var _data = <String, dynamic>{};

  FakeDocumentSnapshot();

  /// Create a [FakeDocumentSnapshot] for use with the toMessage() extension function.
  FakeDocumentSnapshot.forMessage(
      String authorId, String text, Timestamp timestamp) {
    _data = <String, dynamic>{};
    _data.addAll(<String, dynamic>{
      'authorId': authorId,
      'text': text,
      'timestamp': timestamp
    });
  }

  /// Create a [FakeDocumentSnapshot] for use with the toUserItem() extension function.
  FakeDocumentSnapshot.forUserItem(String displayName, dynamic photoURL) {
    _data = <String, dynamic>{};
    _data.addAll(<String, dynamic>{
      'documentID': documentID,
      'displayName': displayName,
      'photoURL': photoURL
    });
  }

  @override
  Map<String, dynamic> data() => _data;

  @override
  dynamic operator [](String key) {
    // TODO: implement []
    throw UnimplementedError();
  }

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

  @override
  dynamic get(dynamic field) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  // TODO: implement id
  String get id => throw UnimplementedError();
}
