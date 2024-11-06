import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/core/const/constants.dart';
import 'package:app/core/const/sentry.dart';
import 'package:app/core/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

part 'user_service_impl.dart';

final userServiceProvider = Provider<UserService>(
  (ref) {
    return UserServiceImpl();
  },
);

abstract class UserService {
  bool isLoggedIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<dynamic> login(String email, String password);
  getCurrentUserStream();
  Future registerUser({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  });
  Future<UserCredential?> loginWithGoogle();
  Future<UserCredential?> registerWithGoogle();
  Future<PackageInfo> getPlatformInfo();
  Future<ConfirmationResult> signInWithPhoneNumber(String phoneNumber);
  Future forgotPassword(String email);
  Future verifyEmail(String email);
  Future logout();
  Future<UserData?> getUserDBData();
  Future<void> updateUserProfilePhoto(String url);
  Future<UserData?> updateUserProfile(UserData userData);
}
