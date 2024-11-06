// ignore_for_file: avoid_logInfo

import 'package:app/core/const/constants.dart';
import 'package:app/core/const/sentry.dart';
import 'package:app/core/extensions/app_view_model.dart';
import 'package:app/core/services/authentication/user_service.dart';
import 'package:app/features/dashboard/dashboard_root.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final viewModelProvider =
    ChangeNotifierProvider.autoDispose<LoginViewModel>((ref) {
  return LoginViewModel(ref);
});

class LoginViewModel extends AppViewModel {
  LoginViewModel(Ref ref)
      : _authenticationService = ref.read(userServiceProvider);

  final UserService _authenticationService;
  String email = '';
  String password = '';
  bool passwordVisible = false;

  Future login() async {
    loading = true;
    notifyListeners();
    final cred = await _authenticationService
        .login(email, password)
        .catchError((err, s) {
      logSentry(err, s);

      logInfo(err);
      logInfo(s);

      showSnackBarMessage('Login failed: ${err.toString()}');
      return null;
    });

    if (cred is UserCredential && cred.user != null) {
      goToDashboard(cred.user!.phoneNumber);
    } else if (cred is String) {
      logInfo(cred);
      logInfo('Showing SnackBar');

      showSnackBarMessage(
        'Login failed: $cred',
      );
    }
    loading = false;
    notifyListeners();
  }

  Future loginWithGoogle() async {
    loading = true;
    notifyListeners();
    final cred =
        await _authenticationService.loginWithGoogle().catchError((err, s) {
      logSentry(err, s);

      logInfo(err);
      logInfo(s);

      showSnackBarMessage('Login failed: $err');
      return null;
    });
    logInfo(cred?.user?.toString() ?? 'null');
    if (cred?.user != null) {
      logInfo(cred?.user!.email);
      // _authenticationService.loginBackend(cred);

      goToDashboard(cred!.user!.phoneNumber);
    } else {
      showSnackBarMessage('Login failed');
    }
    loading = false;
    notifyListeners();
  }

  void goToDashboard(String? phoneNumber) {
    navigationGo(DashboardRoot.path);
  }

  void updateEmail(String emailAdd) {
    email = emailAdd;
    notifyListeners();
  }

  void updatePassword(String pass) {
    password = pass;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }
}
