import 'package:app/core/extensions/app_view_model.dart';
import 'package:app/core/services/authentication/user_service.dart';
import 'package:app/features/dashboard/dashboard_root.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final viewModelProvider =
    ChangeNotifierProvider.autoDispose<ForgotPasswordViewModel>((ref) {
  return ForgotPasswordViewModel(ref);
});

class ForgotPasswordViewModel extends AppViewModel {
  ForgotPasswordViewModel(Ref ref)
      : _authenticationService = ref.read(userServiceProvider);

  final UserService _authenticationService;
  String email = '';
  String password = '';
  bool passwordVisible = false;

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

  Future forgotPassword() async {
    loading = true;
    notifyListeners();
    final result = await _authenticationService.forgotPassword(email);

    showSnackBarMessage(
      'Reset link sent to $email',
    );
    loading = false;
    notifyListeners();
    return result;
  }

  Future<void> loginUser(String password) async {
    final userCred = await _authenticationService.login(email, password);

    if (userCred != null) {
      navigationGo(DashboardRoot.path);
    }
  }
}
