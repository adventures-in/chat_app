import 'package:adventures_in_chat_app/models/conversation_item.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

class ConversationsViewModel extends ChangeNotifier {
  ConversationsViewModel(List<ConversationItem> items) : _items = items;

  /// Internal, private state of the model.
  final List<ConversationItem> _items;

  /// Adds a ConversationItem to the view model.
  void add({@required ConversationItem item}) {
    _items.add(item);
    // Tell the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes a ConversationItem from the view model.
  void remove({@required ConversationItem item}) {
    _items.remove(item);
    // Tell the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Sets the list of conversations
  void populateWith(List<ConversationItem> models) {
    _items.clear();
    _items.addAll(models);
  }
}
