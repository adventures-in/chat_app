import 'dart:collection';

import 'package:adventures_in_chat_app/extensions/extensions.dart';
import 'package:adventures_in_chat_app/models/user_item.dart';
import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:adventures_in_chat_app/widgets/shared/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSearchPage extends StatelessWidget {
  UserSearchPage();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserSearchViewModel(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Select a friend'),
          ),
          body: UserList()),
    );
  }
}

class UserList extends StatefulWidget {
  UserList();
  // final UserItem currentUserItem;
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Consumer<UserSearchViewModel>(builder: (context, selections, child) {
          return Row(children: [
            Row(children: selections.selectedWidgets),
            SaveButton()
          ]);
        }),
        Expanded(
          child: StreamBuilder(
              stream: Firestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final querySnapshot = snapshot.data as QuerySnapshot;

                final currentUserId = context.db.currentUserId;
                // remove our own document from the list
                final filteredUserList = <UserItem>[];
                for (final docSnapshot in querySnapshot.documents) {
                  if (docSnapshot.documentID != currentUserId) {
                    filteredUserList.add(UserItem(
                        uid: docSnapshot.documentID,
                        displayName: docSnapshot['displayName'] as String,
                        photoURL: docSnapshot.data['photoURL'] as String));
                  }
                }

                // the model needs to be declared outside of the onTap callback
                final model = Provider.of<UserSearchViewModel>(context);

                model.populateWith(filteredUserList);

                return Consumer<UserSearchViewModel>(
                    builder: (context, selections, child) {
                  return ListView.builder(
                    itemCount: model._unselectedItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final userItem = model._unselectedItems[index];
                      return ListTile(
                          leading: UserAvatar(url: userItem.photoURL),
                          title: Text(userItem.displayName),
                          onTap: () {
                            model.select(item: userItem);
                          });
                    },
                  );
                });
              }),
        ),
      ],
    );
  }
}

class SaveButton extends StatefulWidget {
  SaveButton();

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool saving = false;
  @override
  Widget build(BuildContext context) {
    if (saving) return CircularProgressIndicator();
    return IconButton(
        icon: Icon(Icons.done),
        onPressed: () {
          // get all the selected users
          final selectedItems =
              Provider.of<UserSearchViewModel>(context, listen: false)
                  ._selectedItems;

          // restructure the data for saving to firestore
          final uids = selectedItems.map((item) => item.uid).toList();
          final displayNames =
              selectedItems.map((item) => item.displayName).toList();
          final photoURLs = selectedItems.map((item) => item.photoURL).toList();
          final db = context.db;

          db
              .createConversation(uids, displayNames, photoURLs)
              .then<void>((item) => Navigator.pop(context, item));

          // disable the button and give feedback to user of waiting state
          setState(() {
            saving = true;
          });
        });
  }
}

class UserSearchViewModel extends ChangeNotifier {
  /// Internal, private state of the model.
  final Set<UserItem> _selectedItems = {};
  final List<UserItem> _unselectedItems = [];

  /// Unmodifiable views of the widgets in the model.
  UnmodifiableListView<Widget> get selectedWidgets => UnmodifiableListView(
      _selectedItems.map((item) => UserAvatar(url: item.photoURL)));
  UnmodifiableListView<Widget> get unselectedWidgets => UnmodifiableListView(
      _unselectedItems.map((item) => UserAvatar(url: item.photoURL)));

  /// These are the only way to modify the cart from outside.
  /// Selects a UserItem.
  void select({@required UserItem item}) {
    _unselectedItems.remove(item);
    _selectedItems.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Adds all users as unselected
  /// TODO: Currently this is run whenever a user is selected due to the change
  /// notifier structure. The check for an empty list acts as a first build flag
  /// and works for now but is not ideal
  void populateWith(List<UserItem> models) {
    if (_selectedItems.isEmpty) {
      _unselectedItems.addAll(models);
    }
  }
}
