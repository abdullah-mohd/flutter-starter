import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

export 'color_constants.dart';
export 'asset_constants.dart';
// ------------ URLS ------------

void logInfo(dynamic info) {
  if (kDebugMode) {
    print(info);
  }
}

final kTestingUid = FirebaseAuth.instance.currentUser!.uid;
