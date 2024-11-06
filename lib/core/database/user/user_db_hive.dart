import 'dart:async';

import 'package:hive_flutter/adapters.dart';
import 'package:app/core/database/database.dart';
import 'package:app/core/database/hive.dart';
import 'package:app/core/database/user/user_db.dart';

class UserDBHive implements UserDB {
  LazyBox? _box;

  FutureOr<LazyBox> _getBox() async {
    if (_box == null) {
      final appDocDir = await getDatabaseDirectory();
      _box ??= await Hive.openLazyBox(storeUserState, path: appDocDir);
    }

    return _box!;
  }
}
