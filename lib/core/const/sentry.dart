import 'package:sentry_flutter/sentry_flutter.dart';

void logSentry(dynamic exception, dynamic stackTrace) async {
  await Sentry.captureException(
    exception,
    stackTrace: stackTrace,
  );
}
