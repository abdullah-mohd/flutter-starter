import 'package:app/core/database/user/user_db_hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appStateDBProvider = Provider<UserDB>(
  (_) => UserDBHive(),
);

abstract class UserDB {}
