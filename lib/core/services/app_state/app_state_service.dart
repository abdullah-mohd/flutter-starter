import 'dart:async';
import 'package:app/core/const/constants.dart';
import 'package:app/core/theme/theme.dart';
import 'package:app/core/database/app_state/app_state_db.dart';
import 'package:app/core/services/authentication/user_service.dart';
import 'package:app/features/authentication/login/login_page.dart';
import 'package:app/features/dashboard/dashboard_root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';

final appStateServiceProvider = StateProvider<AppStateService>((ref) {
  return AppStateServiceImpl(ref);
});

abstract class AppStateService {
  Future<void> init();

  StateProvider<bool> get haveInitializedAppProvider;

  StateProvider<String> get routeProvider;
  String? currentRoute;
}

class AppStateServiceImpl extends AppStateService {
  final Ref _ref;
  final AppStateDB _appStateDB;

  final _haveInitializedAppProvider = StateProvider<bool>((ref) {
    return false;
  });

  void dispose() {
    Hive.close();
  }

  @override
  StateProvider<bool> get haveInitializedAppProvider =>
      _haveInitializedAppProvider;

  @override
  StateProvider<String> routeProvider = StateProvider<String>((ref) {
    logInfo('----------- Instantiation ROUTE PROVIDER');
    return '/';
  });

  AppStateServiceImpl(Ref ref)
      : _ref = ref,
        _appStateDB = ref.read(appStateDBProvider);

  Future<void> initCrashlytics() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    if (!kDebugMode) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }
  }

  @override
  Future<void> init() async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      logInfo('${record.level.name}: ${record.time}: ${record.message}');
      if (record.stackTrace != null) {
        logInfo(record.stackTrace);
      }
    }).onError((error) {
      logInfo('ERROR: $error');
    });

    if (!kIsWeb) await initCrashlytics();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    await Hive.initFlutter();
    final currentRoute = _ref.watch(routeProvider.notifier);
    final UserService auth = _ref.watch(userServiceProvider);

    if (auth.isLoggedIn()) {
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.setUserIdentifier(
          auth.firebaseAuth.currentUser!.uid,
        );
      }
      currentRoute.state = DashboardRoot.path;
    } else {
      currentRoute.state = LoginPage.path;
    }
    var currentThemeId = await _appStateDB.getCurrentThemeId();

    if (currentThemeId == null) {
      currentThemeId = defaultThemeId;
      await _appStateDB.setCurrentThemeId(currentThemeId);
    }

    _ref.read(themeProvider).setCurrentThemeId(currentThemeId);
    _ref.read(_haveInitializedAppProvider.notifier).state = true;
  }
}
