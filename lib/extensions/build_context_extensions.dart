import 'package:adventures_in_chat_app/services/database_service.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension DatabaseServiceExt on BuildContext {
  DatabaseService get db {
    return Provider.of<DatabaseService>(this, listen: false);
  }
}
