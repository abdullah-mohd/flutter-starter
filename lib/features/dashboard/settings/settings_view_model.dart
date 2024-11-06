import 'package:app/core/extensions/app_view_model.dart';
import 'package:app/core/database/app_state/app_state_db.dart';
import 'package:app/core/models/user_data.dart';
import 'package:app/core/services/authentication/user_service.dart';
import 'package:app/features/dashboard/dashboard_root.dart';
import 'package:app/features/dashboard/dashboard_view_model.dart';
import 'package:app/features/dashboard/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Every viewModel has this viewModelProvider hooked with it, this is global and can be referred anywhere within the app.
// This allows us to be unique and consistent with our viewModelProvider naming convention and allows
// us to follow singleton method properly. So now, our App will only have 1 dashboard instance or 1 respective service instance.
final viewModelProvider = ChangeNotifierProvider<SettingsViewModel>((ref) {
  return SettingsViewModel(ref);
});

class SettingsViewModel extends AppViewModel {
  SettingsViewModel(Ref ref)
      : _ref = ref,
        userService = ref.watch(userServiceProvider),
        appStateDB = ref.watch(appStateDBProvider);

  late DashboardViewModel dashboardVM;
  final Ref _ref;
  final AppStateDB appStateDB;
  final UserService userService;
  UserData? userData;

  String autoTriggerType = 'distance';

  int? autoTriggerValue;

  String preferredUnit = 'metric';
  String videoOrientation = 'metric';

  User get currentUser => userService.firebaseAuth.currentUser!;

  @override
  Future<void> init() async {
    loading = true;

    dashboardVM = _ref.read(dashboardViewModelProvider);
    userData = dashboardVM.currentUserData;

    autoTriggerType = userData!.autoTriggerType ?? 'distance';
    autoTriggerValue = userData!.autoTriggerValue;
    preferredUnit = userData!.preferredUnit ?? 'metric';
    videoOrientation = userData!.videoOrientation ?? 'landscape';
    loading = false;

    return super.init();
  }

  void setAutoTriggerType(String type) {
    autoTriggerType = type;
    notifyListeners();
  }

  void updateAutoTriggerValue(String value) {
    autoTriggerValue = int.parse(value);
    notifyListeners();
  }

  void setPreferredUnit(String unit) {
    preferredUnit = unit;
    notifyListeners();
  }

  void setVideoOrientation(String orientation) {
    videoOrientation = orientation;
    notifyListeners();
  }

  void goToDashboard() {
    navigationGo(DashboardRoot.path);
    final dashboardVM = _ref.read(dashboardViewModelProvider);
    dashboardVM.getUserDBData();
    dashboardVM.setActivePage(const HomeView());
  }

  Future<void> saveUserSettings() async {
    loading = true;

    if (preferredUnit != userData!.preferredUnit) {
      userData!.preferredUnit = preferredUnit;
    }

    if (videoOrientation != userData!.videoOrientation) {
      userData!.videoOrientation = videoOrientation;
    }

    if (autoTriggerType != userData!.autoTriggerType) {
      userData!.autoTriggerType = autoTriggerType;
    }
    if (autoTriggerValue != userData!.autoTriggerValue) {
      userData!.autoTriggerValue = autoTriggerValue;
    }

    final result = await userService.updateUserProfile(userData!);

    if (result != null) {
      showSnackBarMessage('Settings saved successfully!');
      Future.delayed(const Duration(seconds: 2), () => goToDashboard());
    } else {
      showSnackBarMessage('Settings update failed!');
    }
    loading = false;
  }
}
