// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/core/const/constants.dart';
import 'package:app/core/const/sentry.dart';
import 'package:app/core/extensions/app_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/models/user_data.dart';
import 'package:app/core/services/authentication/user_service.dart';
import 'package:app/features/authentication/login/login_page.dart';
import 'package:app/features/dashboard/home/home_view.dart';

final dashboardViewModelProvider =
    ChangeNotifierProvider.autoDispose<DashboardViewModel>((ref) {
  return DashboardViewModel(ref);
});

class DashboardViewModel extends AppViewModel {
  DashboardViewModel(Ref ref)
      : _ref = ref,
        authenticationService = ref.read(userServiceProvider);

  // ignore: unused_field
  final Ref _ref;

  Widget activePage = const HomeView();

  Widget? lastPage;
  final UserService authenticationService;

  User? currentUser;

  UserData? currentUserData;
  Stream<UserData?>? userStream;
  StreamSubscription? userStreamSub;
  @override
  Future<void> init() async {
    super.init();
    loading = true;
    await getUserDBData();
    userStream = authenticationService.getCurrentUserStream();

    userStreamSub = userStream!.listen((userData) async {
      currentUserData = userData;
      logInfo(currentUserData);
      notifyListeners();
    });

    loading = false;
  }

  Future goToDonate() async {
    await launchUrl(Uri.parse("https://www.vcorso.com/donate"))
        .catchError((err, s) {
      logSentry(err, s);
      logInfo(err);
      logInfo(s);
      return false;
    });
  }

  Future getUserDBData() async {
    currentUserData = await authenticationService.getUserDBData();
    notifyListeners();
  }

  void setActivePage(Widget page) {
    activePage = page;
    notifyListeners();
  }

  Future<void> logoutUser() async {
    loading = true;
    notifyListeners();
    if (userStreamSub != null) {
      userStreamSub!.cancel();
    }
    await authenticationService.logout();

    await Future.delayed(Duration(seconds: 3));
    loading = false;
    notifyListeners();
    navigationGo(LoginPage.path);
  }

  Widget getUserImage(double height) {
    if (currentUserData?.imageUrl != null) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        height: height,
        width: height,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: currentUserData!.imageUrl!,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        height: height,
        width: height,
        child: ClipOval(
          child: Image.asset(
            'assets/contact.png',
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
