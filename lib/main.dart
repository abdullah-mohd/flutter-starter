import 'dart:async';

import 'package:app/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:app/core/const/constants.dart';
import 'package:app/core/const/sentry.dart';
import 'package:app/core/extensions/app_consumer_state.dart';
import 'package:app/core/services/app_state/app_state_service.dart';
import 'package:app/core/theme/theme.dart';
import 'package:app/features/widgets/const_widgets.dart';
import 'package:app/router.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  logInfo('Handling a background message ${message.messageId}');
}

// ---------- NOTIFICATIONS -----------
void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SentryFlutter.init(
      (options) {
        options.dsn = "";
        options.tracesSampleRate = 1.0;
        options.profilesSampleRate = 1.0;
      },
    );
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseAppCheck.instance
        .activate(
      androidProvider:
          kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttestWithDeviceCheckFallback,
    )
        .catchError((err, s) {
      logSentry(err, s);
    }).then((value) {
      logInfo('Firebase App Check Activated');
    });

    runApp(
      ProviderScope(
        child: AppName(),
      ),
    );
  }, (exception, stackTrace) async {
    await Sentry.captureException(exception, stackTrace: stackTrace);
  });
}

class AppName extends ConsumerStatefulWidget {
  const AppName({super.key});

  @override
  AppConsumerState<ConsumerStatefulWidget> createState() => _AppNameState();
}

class _AppNameState extends AppConsumerState<AppName> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final appStateService = ref.read(appStateServiceProvider);
    await appStateService.init();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateServiceProvider);
    final haveInitializedApp = ref.watch(appState.haveInitializedAppProvider);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      statusBarColor: Colors.black,
    ));
    if (!haveInitializedApp) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xfff3f3f3),
          body: Center(
            child: AppLoader(),
          ),
        ),
      );
    } else {
      final theme = ref.watch(themeProvider).current.themeData;
      final router = ref.watch(routerProvider);

      return Layout(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: theme,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
          title: 'AppName',
        ),
      );
    }
  }
}
