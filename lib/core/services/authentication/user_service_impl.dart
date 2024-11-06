part of 'user_service.dart';

class UserServiceImpl implements UserService {
  @override
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  bool isLoggedIn() {
    return firebaseAuth.currentUser != null &&
        firebaseAuth.currentUser?.uid != null;
  }

  @override
  Stream<UserData?> getCurrentUserStream() {
    final uid = firebaseAuth.currentUser!.uid;
    return firestore.collection('users').doc(uid).snapshots().map((event) {
      if (event.data() != null) {
        return UserData.fromJson(
          event.data()!,
        );
      }
    }).asBroadcastStream();
  }

  @override
  Future<void> updateUserProfilePhoto(String url) async {
    return firebaseAuth.currentUser!.updatePhotoURL(url);
  }

  @override
  Future<dynamic> login(String email, String password) async {
    try {
      final resp = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return resp;
    } on FirebaseAuthException catch (e, s) {
      logInfo(e);
      logInfo(s);

      if (e.code == 'user-not-found') {
        return 'User Not Found';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return 'Invalid Password';
      } else if (e.message!.toLowerCase().contains('too many attempts')) {
        return 'Too many attempts. Device blocked for 10 minutes';
      } else {
        logInfo('---------XXX');
        logInfo(e.code);
        logInfo(e.message);
        return e.message;
      }
    }
  }

  @override
  Future<ConfirmationResult> signInWithPhoneNumber(String phoneNumber) async {
    final result = await firebaseAuth.signInWithPhoneNumber(
      phoneNumber,
    );
    return result;
  }

  @override
  Future registerUser({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    String? imageUrl,
  }) async {
    final uid = firebaseAuth.currentUser!.uid;
    final ref = firestore.collection('users').doc(uid);
    final resp = await ref.set(
      {
        "id": uid,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "imageUrl": imageUrl,
        "phoneNumber": phoneNumber,
        "createdAt": DateTime.now().toUtc().toIso8601String(),
      },
      SetOptions(merge: true),
    );
    return resp;
  }

  Future<http.Response> postRequest(
    String url,
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization":
            "Bearer ${await firebaseAuth.currentUser!.getIdToken()}",
      },
      body: jsonEncode(data),
    );
    return response;
  }

  @override
  Future forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
    return;
  }

  @override
  Future verifyEmail(String email) async {
    await firebaseAuth.currentUser?.sendEmailVerification();
  }

  @override
  Future logout() async {
    final List<Future> futures = [
      GoogleSignIn().signOut(),
      firebaseAuth.signOut(),
    ];
    final result = await Future.wait(futures).catchError((err, s) {
      logInfo(err);
      logInfo(s);
      return [];
    });
    return result;
  }

  @override
  Future<PackageInfo> getPlatformInfo() async {
    final appInfo = await PackageInfo.fromPlatform();

    return appInfo;
  }

  @override
  Future<UserCredential?> loginWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn().catchError((err, s) {
      logInfo(err);
      logInfo(s);
      logSentry(err, s);
      return null;
    });

    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCred = await firebaseAuth.signInWithCredential(
        credential,
      );
      final userData = await getUserDBData();
      if (userData == null) {
        final displayName = googleUser.displayName;
        var firstName = '';
        var lastName = '';
        if (displayName != null) {
          if (displayName.contains(' ')) {
            final updatedName = displayName.split(' ');
            firstName = updatedName.removeAt(0);
            lastName = updatedName.join(' ');
          } else {
            firstName = displayName;
            lastName = '';
          }
        }
        await registerUser(
          email: googleUser.email,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: '',
          imageUrl: googleUser.photoUrl,
        );
      }
      return userCred;
    } else {
      return null;
    }
  }

  @override
  Future<UserCredential?> registerWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential

      final userCred = await firebaseAuth.signInWithCredential(
        credential,
      );

      final displayName = googleUser.displayName;
      var firstName = '';
      var lastName = '';
      if (displayName != null) {
        if (displayName.contains(' ')) {
          firstName = displayName.split(' ')[0];
          lastName = displayName.split(' ')[1];
        } else {
          firstName = displayName;
          lastName = '';
        }
      }

      await registerUser(
        email: googleUser.email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: '',
        imageUrl: googleUser.photoUrl,
      );
      return userCred;
    } else {
      return null;
    }
  }

  @override
  Future<UserData?> getUserDBData() async {
    if (firebaseAuth.currentUser != null) {
      final query = await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get()
          // ignore: body_might_complete_normally_catch_error
          .catchError((err, s) {
        logInfo(err);
        logInfo(s);

        logSentry(err, s);
      });

      if (query.data() != null) {
        return UserData.fromJson(
          query.data()!,
        );
      } else {
        logInfo('No info found');
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<UserData?> updateUserProfile(UserData userData) {
    try {
      final result = firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set(
            userData.toJson(),
            SetOptions(merge: true),
          )
          .then((value) => userData);

      return result;
    } catch (e) {
      logInfo(e.toString());
      return Future.value();
    }
  }
}
