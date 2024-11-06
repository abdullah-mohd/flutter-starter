import 'package:flutter/foundation.dart';
import 'package:app/core/extensions/app_view_model.dart';
import 'package:app/core/database/app_state/app_state_db.dart';
import 'package:app/core/models/user_data.dart';
import 'package:app/core/services/authentication/user_service.dart';
import 'package:app/features/dashboard/dashboard_root.dart';
import 'package:app/features/dashboard/dashboard_view_model.dart';
import 'package:app/features/dashboard/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Every viewModel has this viewModelProvider hooked with it, this is global and can be referred anywhere within the app.
// This allows us to be unique and consistent with our viewModelProvider naming convention and allows
// us to follow singleton method properly. So now, our App will only have 1 dashboard instance or 1 respective service instance.
final viewModelProvider =
    ChangeNotifierProvider.autoDispose<ProfileViewModel>((ref) {
  return ProfileViewModel(ref);
});

class ProfileViewModel extends AppViewModel {
  ProfileViewModel(Ref ref)
      : _ref = ref,
        userService = ref.watch(userServiceProvider),
        appStateDB = ref.watch(appStateDBProvider);

  final Ref _ref;
  final AppStateDB appStateDB;
  final UserService userService;
  UserData? userData;

  XFile? imageFile;
  Uint8List? photoBytes;
  String? pronounValue;
  String? name;
  String? surname;
  String? videoName;

  User get currentUser => userService.firebaseAuth.currentUser!;

  @override
  Future<void> init() async {
    loading = true;

    userData = await userService.getUserDBData();

    name = userData?.firstName;
    surname = userData?.lastName;
    videoName = userData?.videoName;
    pronounValue = userData?.pronoun;
    loading = false;

    notifyListeners();
    return super.init();
  }

  void updateName(String value) {
    name = value;
    notifyListeners();
  }

  void updateSurname(String value) {
    surname = value;
    notifyListeners();
  }

  void updateVideoName(String value) {
    videoName = value;
    notifyListeners();
  }

  void setPronounValue(String value) {
    pronounValue = value;
    notifyListeners();
  }

  Future uploadUserImage() async {
    final result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (result != null) {
      imageFile = XFile(result.path);
      photoBytes = await imageFile!.readAsBytes();
    } else {
      //logInfo('No file selected');
    }
    notifyListeners();
  }

  Future saveUpload() async {
    if (imageFile != null) {
      final String fileName = imageFile!.path.split('/').last;
      //logInfo(fileName);
      // Upload file
      final TaskSnapshot storageUpload = await FirebaseStorage.instance
          .ref('users/${currentUser.uid}/$fileName')
          .putData(
            photoBytes ?? await imageFile!.readAsBytes(),
          );
      final String downloadUrl = await storageUpload.ref.getDownloadURL();
      userData!.imageUrl = downloadUrl;

      userService.updateUserProfilePhoto(downloadUrl);
    } else {
      //logInfo('No file selected');
      showSnackBarMessage(
        'No file selected, please select a file to upload before saving',
      );
    }
  }

  void goToDashboard() {
    navigationGo(DashboardRoot.path);
    final dashboardVM = _ref.read(dashboardViewModelProvider);
    dashboardVM.getUserDBData();
    dashboardVM.setActivePage(const HomeView());
  }

  Future<void> saveUserProfile() async {
    loading = true;
    if (imageFile != null) {
      await saveUpload();
    }

    if (name != null) {
      userData!.firstName = name!;
    }

    if (surname != null) {
      userData!.lastName = surname!;
    }
    if (videoName != null) {
      userData!.videoName = videoName!;
    }

    if (pronounValue != null) {
      userData!.pronoun = pronounValue!;
    }

    final result = await userService.updateUserProfile(userData!);

    if (result != null) {
      showSnackBarMessage('Profile updated successfully!');
      Future.delayed(const Duration(seconds: 2), () => goToDashboard());
    } else {
      showSnackBarMessage('Profile update failed!');
    }
    loading = false;
  }
}
