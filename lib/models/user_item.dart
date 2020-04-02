import 'package:meta/meta.dart';

/// A user item used in lists, has the minimal info needed to
/// display a user item.
class UserItem {
  UserItem(
      {@required this.uid,
      @required this.displayName,
      @required this.photoURL});

  final String uid;
  final String displayName;
  final String photoURL;

  // User items with the same id are considered equivalent
  @override
  bool operator ==(dynamic o) => o.runtimeType == UserItem && o.uid == uid;
  @override
  int get hashCode => uid.hashCode;
}
