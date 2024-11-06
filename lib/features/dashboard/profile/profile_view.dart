import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/core/const/constants.dart';
import 'package:app/core/const/sentry.dart';
import 'package:app/core/extensions/app_consumer_state.dart';
import 'package:app/core/theme/app_text.dart';
import 'package:app/core/theme/theme.dart';
import 'package:app/features/dashboard/dashboard_view_model.dart';
import 'package:app/features/dashboard/profile/profile_view_model.dart';
import 'package:app/features/widgets/const_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';
import 'package:app/features/widgets/form_inputs/app_text_field.dart';

class ProfilePage extends ConsumerStatefulWidget {
  static String get name => 'Profile';

  static String get path => '/profile';
  const ProfilePage({super.key});

  @override
  AppConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends AppConsumerState<ProfilePage> {
  late ProfileViewModel viewModel;
  late DashboardViewModel dashVM;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    viewModel = ref.read(viewModelProvider);
    viewModel.init();
    viewModel.setAppConsumerState(this);

    super.initState();
  }

  Container _getUserImage(double height) {
    final viewModel = ref.watch(viewModelProvider);
    final userData = viewModel.userData;
    final imageFile = viewModel.imageFile;
    if (userData!.imageUrl != null) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        height: height,
        width: height,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: userData.imageUrl!,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (imageFile != null) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        height: height,
        width: height,
        child: ClipOval(
          child: Image.memory(
            viewModel.photoBytes!,
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
        child: ClipOval(
          child: Image.asset(
            'assets/contact.png',
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(viewModelProvider);
    dashVM = ref.watch(dashboardViewModelProvider);
    final appThemeData = ref.watch(themeProvider);
    final appTheme = appThemeData.current.themeData;
    final currentUserData = viewModel.userData;

    logInfo(currentUserData);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 3,
        surfaceTintColor: appTheme.scaffoldBackgroundColor,
        foregroundColor: appTheme.scaffoldBackgroundColor,
        backgroundColor: appTheme.scaffoldBackgroundColor,
        shadowColor: appTheme.scaffoldBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                viewModel.goToDashboard();
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.keyboard_arrow_left_rounded,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            Spacer(),
            AppText(
              'Profile',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            Spacer(),
            Container(
              width: 40,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          ...backdropWidgets(context, appTheme),
          Container(
            height: context.layout.height,
            padding: EdgeInsets.symmetric(
              horizontal: 0.0,
            ),
            width: context.layout.width,
            child: SafeArea(
              child: viewModel.loading
                  ? const Center(child: AppLoader())
                  : Container(
                      color: Colors.white,
                      // alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.0,
                      ),
                      height: context.layout.height,
                      width: context.layout.width,
                      child: Form(
                        key: formKey,
                        child: ListView(
                          shrinkWrap: true,
                          primary: true,
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  sized(h: 35),
                                  Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      // borderRadius: BorderRadius.circular(25),
                                    ),
                                    height: 130,
                                    width: 130,
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(150),
                                      child: _getUserImage(130),
                                    ),
                                  ),
                                  sized(
                                    h: 20,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 120,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        viewModel.uploadUserImage();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            appTheme.colorScheme.background,
                                        fixedSize: const Size(105, 31),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide(
                                            color: appTheme.colorScheme.primary,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Change',
                                        style: appTheme.textTheme.bodyMedium!
                                            .copyWith(
                                          color: appTheme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  sized(
                                    h: 40,
                                  ),
                                ],
                              ),
                            ),
                            sized(h: 20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  AppTextField(
                                    value: viewModel.name,
                                    onChanged: (v) {
                                      viewModel.updateName(v);
                                    },
                                    onSaved: (v) {
                                      if (v != null) viewModel.updateName(v);
                                    },
                                    label: "Name",
                                    hint: "Enter your name",
                                  ),
                                  sized(h: 20),
                                  AppTextField(
                                    value: viewModel.surname,
                                    onChanged: (v) {
                                      viewModel.updateSurname(v);
                                    },
                                    onSaved: (v) {
                                      if (v != null) viewModel.updateSurname(v);
                                    },
                                    label: "Surname",
                                    hint: "Enter your surname",
                                  ),
                                  sized(h: 20),
                                  AppTextField(
                                    value: viewModel.videoName,
                                    onChanged: (v) {
                                      viewModel.updateVideoName(v);
                                    },
                                    onSaved: (v) {
                                      if (v != null) {
                                        viewModel.updateVideoName(v);
                                      }
                                    },
                                    label: "Video Name",
                                    hint: "Name to use in your video",
                                  ),
                                  sized(h: 30),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        'Pronoun',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      sized(h: 20),
                                      ListTile(
                                        onTap: () {
                                          viewModel.setPronounValue('he');
                                        },
                                        leading: AppText('He/him'),
                                        trailing: Radio(
                                            activeColor:
                                                appTheme.colorScheme.primary,
                                            fillColor: WidgetStateProperty.all(
                                                viewModel.pronounValue == 'he'
                                                    ? appTheme
                                                        .colorScheme.primary
                                                    : Colors.grey),
                                            value: 'he',
                                            groupValue: viewModel.pronounValue,
                                            onChanged: (v) {
                                              viewModel.setPronounValue(
                                                  v.toString());
                                            }),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          viewModel.setPronounValue('she');
                                        },
                                        leading: AppText('She/her'),
                                        trailing: Radio(
                                            activeColor:
                                                appTheme.colorScheme.primary,
                                            fillColor: WidgetStateProperty.all(
                                                viewModel.pronounValue == 'she'
                                                    ? appTheme
                                                        .colorScheme.primary
                                                    : Colors.grey),
                                            value: 'she',
                                            groupValue: viewModel.pronounValue,
                                            onChanged: (v) {
                                              viewModel.setPronounValue(
                                                  v.toString());
                                            }),
                                      ),
                                      // ListTile(
                                      //   onTap: () {
                                      //     viewModel.setPronounValue('they');
                                      //   },
                                      //   leading: AppText('Them/they'),
                                      //   trailing: Radio(
                                      //       activeColor:
                                      //           appTheme.colorScheme.primary,
                                      //       fillColor: WidgetStateProperty.all(
                                      //           viewModel.pronounValue == 'they'
                                      //               ? appTheme
                                      //                   .colorScheme.primary
                                      //               : Colors.grey),
                                      //       value: 'they',
                                      //       groupValue: viewModel.pronounValue,
                                      //       onChanged: (v) {
                                      //         viewModel.setPronounValue(
                                      //             v.toString());
                                      //       }),
                                      // )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            sized(
                              h: 20,
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  final form = formKey.currentState;

                                  if (form != null && form.validate()) {
                                    form.save();
                                    viewModel
                                        .saveUserProfile()
                                        .catchError((err, s) {
                                      logSentry(err, s);
                                      logInfo(err);
                                      logInfo(s);
                                    });
                                  } else {}
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize:
                                      Size(context.layout.maxWidth * 0.6, 50),
                                  maximumSize:
                                      Size(context.layout.width * 0.9, 50),
                                  backgroundColor: Colors.black,
                                  fixedSize: const Size(120, 27),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      color: appTheme.colorScheme.primary,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: AppText(
                                  'Save',
                                  maxLines: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            sized(h: 20),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
