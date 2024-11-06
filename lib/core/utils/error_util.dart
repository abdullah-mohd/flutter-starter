// ignore: avoid_classes_with_only_static_members
class ErrorUtil {
  static const errorCodeUnknown = 1000;
  static const errorCodeConnectionError = 1001;
  static const errorCodeInvalidClientPlatform = 1002;
  static const errorCodeMalformedResponse = 1003;
  static const errorCodeNotLoggedIn = 1003;
  static const errorCodeNoHandlerForRequestPath = 1004;

  static String getErrorMessage(int errorCode) {
    switch (errorCode) {
      case errorCodeUnknown:
        return 'An unknown error occurred. Please again try later.';
    }

    return 'An unknown error occurred. Please again try later.';
  }
}
