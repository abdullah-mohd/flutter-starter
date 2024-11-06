// ignore_for_file: avoid_logInfo

import 'dart:async';

import 'package:app/core/const/constants.dart';
import 'package:app/core/const/sentry.dart';
import 'package:app/core/extensions/app_view_model.dart';
import 'package:app/core/services/authentication/user_service.dart';
import 'package:app/features/dashboard/dashboard_root.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// Every viewModel has this viewModelProvider hooked with it, this is global and can be referred anywhere within the app.
// This allows us to be unique and consistent with our viewModelProvider naming convention and allows
// us to follow singleton method properly. So now, our App will only have 1 dashboard instance or 1 respective service instance.
final viewModelProvider =
    ChangeNotifierProvider.autoDispose<RegisterViewModel>((ref) {
  return RegisterViewModel(ref);
});

class RegisterViewModel extends AppViewModel {
  RegisterViewModel(Ref ref)
      : _authenticationService = ref.read(userServiceProvider);

  final UserService _authenticationService;
  String email = '';
  String phoneNumber = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  bool emailVerified = false;
  bool passwordVisible = false;
  String? verificationId;
  int? resendToken;
  User? currentUser;
  bool get isLoggedIn => _authenticationService.isLoggedIn();

  @override
  void dispose() {
    logInfo('***** DISPOSING REGISTER VIEW MODEL *****');
    super.dispose();
  }

  late UserCredential userCredential;

  bool signUpDisabled = false;

  @override
  Future<void> init() {
    currentUser = _authenticationService.firebaseAuth.currentUser;
    _authenticationService.firebaseAuth.userChanges().listen((event) {
      if (event is User) {
        currentUser = event;
      } else {
        currentUser = _authenticationService.firebaseAuth.currentUser;
      }
      notifyListeners();
      logInfo('---------------- USER CHANGES === event: $event');
    });

    return super.init();
  }

  Future registerWithGoogle() async {
    loading = true;
    notifyListeners();
    final cred = await _authenticationService.registerWithGoogle();

    logInfo(cred?.user?.toString() ?? 'null');
    logInfo(cred.runtimeType);
    logInfo(cred?.user);

    if (cred is UserCredential && cred.user != null) {
      // _authenticationService.loginBackend(cred);
      logInfo('---------------------- Navigating to dashboard');
      navigationGo(DashboardRoot.path);
    } else {
      logInfo('---------------------- IN ELSE');
      loading = false;
      showSnackBarMessage('Error Registering, Please try again');
    }
  }

  void updateEmail(String emailAdd) {
    email = emailAdd;
    notifyListeners();
  }

  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  Future<void> onPasswordConfirmed() async {
    await createUserAccount();
    await validateEmail();

    emailVerified = true;
    notifyListeners();
  }

  Future<void> validateEmail() async {
    return _authenticationService.firebaseAuth.currentUser!
        .sendEmailVerification();
  }

  void updatePassword(String pass) {
    password = pass;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void updateFName(String firstName) {
    firstName = firstName;
    notifyListeners();
  }

  void handleSignUpError(dynamic err, dynamic s) {
    if (err.toString().contains('email-already-in-use')) {
      showSnackBarMessage(
        'Email address already in use. Please sign in with the email.',
      );
    } else if (err.toString().contains('invalid-email')) {
      showSnackBarMessage(
        'Invalid Email. Please enter a valid email address.',
      );
    } else if (err.toString().contains('weak-password')) {
      showSnackBarMessage(
        'The password is too weak, please add a stronger password.',
      );
    } else {
      showSnackBarMessage(
        'Error creating user. Please try again.',
      );
    }
  }

  Future<void> createUserAccount() async {
    loading = true;

    final createUser = await _authenticationService.firebaseAuth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        // ignore: body_might_complete_normally_catch_error
        .catchError((err, s) {
      logSentry(err, s);
      logInfo(err);
      logInfo(s);

      handleSignUpError(err, s);
      showSnackBarMessage('Error creating user. $err');
    });

    if (createUser.credential != null) {
      userCredential = createUser;

      if (userCredential.user != null) {
        await userCredential.user!
            .updateDisplayName('$firstName $lastName')
            .then((value) {
          showSnackBarMessage(
            'Updated Display Name',
            backgroundColour: Colors.black,
          );
        });
      } else {
        //logInfo('User is null');
      }
    } else {
      logInfo('-----------------Credential is null');
      // _authenticationService.firebaseAuth.
      final userFb = _authenticationService.firebaseAuth.currentUser;
      if (userFb != null) {
        await userFb.updateDisplayName(
          '$firstName $lastName',
        );
      } else {
        showSnackBarMessage('Auth failed', backgroundColour: Colors.black);
      }
    }
  }

  void updateLName(String lastName) {
    lastName = lastName;
    notifyListeners();
  }

  Future<void> registerUser() async {
    loading = true;
    await _authenticationService
        .registerUser(
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    )
        .catchError((err, s) {
      logSentry(err, s);
      logInfo('Error registering user with Firebase');
      logInfo(err);
      logInfo(s);
    });

    loading = false;
  }
}
