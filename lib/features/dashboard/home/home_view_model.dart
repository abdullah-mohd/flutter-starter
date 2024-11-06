// ignore_for_file: avoid_print

import 'package:app/core/extensions/app_view_model.dart';
import 'package:app/core/services/authentication/user_service.dart';
import 'package:app/features/dashboard/dashboard_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Every viewModel has this viewModelProvider hooked with it, this is global and can be referred anywhere within the app.
// This allows us to be unique and consistent with our viewModelProvider naming convention and allows
// us to follow singleton method properly. So now, our App will only have 1 dashboard instance or 1 respective service instance.
final homeViewModelProvider = ChangeNotifierProvider((ref) {
  return HomeViewModel(ref);
});

class HomeViewModel extends AppViewModel {
  HomeViewModel(Ref ref)
      : dashboardVM = ref.read(dashboardViewModelProvider),
        authenticationService = ref.read(userServiceProvider);
  final DashboardViewModel dashboardVM;
  final UserService authenticationService;
  // final NotificationService notificationService;

  DateTime selectedDate = DateTime.now();

  User? get user => authenticationService.firebaseAuth.currentUser;
  String? garminConnectURL;
}
