import 'package:flutter/foundation.dart';
import 'package:app/core/const/constants.dart';
import 'package:app/core/const/sentry.dart';
import 'package:app/core/extensions/app_consumer_state.dart';
import 'package:app/core/theme/app_text.dart';
import 'package:app/core/theme/theme.dart';
import 'package:app/features/dashboard/settings/settings_view_model.dart';
import 'package:app/features/dashboard/dashboard_view_model.dart';
import 'package:app/features/widgets/const_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:layout/layout.dart';

class SettingsPage extends ConsumerStatefulWidget {
  static String get name => 'Profile';

  static String get path => '/profile';
  const SettingsPage({super.key});

  @override
  AppConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsPageState();
}

class _SettingsPageState extends AppConsumerState<SettingsPage> {
  late SettingsViewModel viewModel;
  late DashboardViewModel dashVM;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    viewModel = ref.read(viewModelProvider);
    viewModel.setAppConsumerState(this);
    viewModel.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = ref.watch(viewModelProvider);
    dashVM = ref.watch(dashboardViewModelProvider);
    final appThemeData = ref.watch(themeProvider);
    final appTheme = appThemeData.current.themeData;
    final currentUserData = viewModel.userData;

    logInfo(currentUserData);
    logInfo(viewModel.videoOrientation);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 3,
        surfaceTintColor: appTheme.scaffoldBackgroundColor,
        foregroundColor: appTheme.scaffoldBackgroundColor,
        backgroundColor: appTheme.scaffoldBackgroundColor,
        shadowColor: appTheme.scaffoldBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                viewModel.goToDashboard();
              },
            ),
            Spacer(),
            AppText(
              'Settings',
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
            Spacer(),
          ],
        ),
      ),
      body: Stack(
        children: [
          ...backdropWidgets(context, appTheme),
          Container(
            height: context.layout.height,
            padding: EdgeInsets.symmetric(
              horizontal: kIsWeb ? context.layout.width * 0.2 : 25.0,
            ),
            width: context.layout.width,
            child: SafeArea(
              child: viewModel.loading
                  ? const Center(child: AppLoader())
                  : Container(
                      color: Colors.white,
                      // alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: kIsWeb ? 100 : 25.0,
                      ),
                      height: context.layout.height,
                      width: context.layout.width,
                      child: Form(
                        key: formKey,
                        child: ListView(
                          shrinkWrap: true,
                          primary: true,
                          children: [
                            sized(h: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: AppText(
                                    'Preferred Unit of Measurement',
                                    fontSize: kIsWeb ? 16 : 12,
                                    maxLines: 3,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black54,
                                  ),
                                ),
                                // sized(w: 20),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: ToggleButtons(
                                      constraints: BoxConstraints(
                                        minWidth: context.layout.width * 0.15,
                                        minHeight: 50,
                                      ),
                                      color: Colors.grey,
                                      fillColor: Colors.white,
                                      selectedBorderColor: Colors.grey,
                                      selectedColor: Colors.black,
                                      disabledBorderColor: Colors.grey,
                                      disabledColor: Colors.grey,
                                      borderRadius: BorderRadius.circular(30.0),
                                      isSelected:
                                          viewModel.preferredUnit == 'metric'
                                              ? [true, false]
                                              : [false, true],
                                      onPressed: (int index) {
                                        if (index == 0) {
                                          viewModel.setPreferredUnit('metric');
                                        } else {
                                          viewModel
                                              .setPreferredUnit('imperial');
                                        }
                                      },
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Text('Metric'),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Text('Imperial'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            sized(h: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: AppText(
                                    'Preferred Video Orientation',
                                    fontSize: kIsWeb ? 16 : 12,
                                    maxLines: 2,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black54,
                                  ),
                                ),
                                // sized(w: 20),
                                Expanded(
                                  flex: 1,
                                  child: DropdownButton(
                                    isExpanded: true,
                                    dropdownColor: Colors.grey[300],
                                    value: viewModel.videoOrientation,
                                    // selectedItemBuilder: (context) {
                                    //   return [
                                    //     AppText(
                                    //       viewModel.videoOrientation,
                                    //       color: Colors.black,
                                    //     ),
                                    //   ];
                                    // },
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'portrait',
                                        child: AppText(
                                          'Portrait',
                                          color: Colors.black,
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'landscape',
                                        child: AppText(
                                          'Landscape',
                                          color: Colors.black,
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'square',
                                        child: AppText(
                                          'Square',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        viewModel.setVideoOrientation(value);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Expanded(
                            //       child: Container(
                            //         alignment: Alignment.center,
                            //         child: ToggleButtons(
                            //           constraints: BoxConstraints(
                            //             minWidth: context.layout.width * 0.2,
                            //             minHeight: 50,
                            //           ),
                            //           color: Colors.grey,
                            //           fillColor: Colors.white,
                            //           selectedBorderColor: Colors.grey,
                            //           selectedColor: Colors.black,
                            //           disabledBorderColor: Colors.grey,
                            //           disabledColor: Colors.grey,
                            //           borderRadius: BorderRadius.circular(30.0),
                            //           isSelected: viewModel.videoOrientation ==
                            //                   'portrait'
                            //               ? [true, false]
                            //               : [false, true],
                            //           onPressed: (int index) {
                            //             if (index == 0) {
                            //               viewModel
                            //                   .setVideoOrientation('portrait');
                            //             } else {
                            //               viewModel
                            //                   .setVideoOrientation('landscape');
                            //             }
                            //           },
                            //           children: const [
                            //             Padding(
                            //               padding: EdgeInsets.symmetric(
                            //                   horizontal: 16.0),
                            //               child: Text('Portrait'),
                            //             ),
                            //             Padding(
                            //               padding: EdgeInsets.symmetric(
                            //                   horizontal: 16.0),
                            //               child: Text('Landscape'),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            sized(h: 30),
                            // AppText(
                            //   'Minimum Auto Video Creation Trigger',
                            //   fontSize: 16,
                            //   fontWeight: FontWeight.w900,
                            //   color: Colors.black54,
                            // ),
                            // sized(h: 20),
                            // ListTile(
                            //   // minTileHeight: 140,
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(8),
                            //   ),
                            //   onTap: () {
                            //     viewModel.setAutoTriggerType('distance');
                            //   },
                            //   leading: Container(
                            //     width: context.layout.width * 0.3,
                            //     // height: 120,
                            //     alignment: Alignment.centerLeft,
                            //     child: Column(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceEvenly,
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: const [
                            //         AppText(
                            //           "Distance",
                            //           fontSize: 20,
                            //         ),
                            //         AppText(
                            //           "Minimum distance covered to trigger video creation",
                            //           fontSize: 11,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            //   trailing: Radio(
                            //     activeColor: appTheme.colorScheme.primary,
                            //     fillColor: WidgetStateProperty.all(
                            //         viewModel.autoTriggerType == 'distance'
                            //             ? appTheme.colorScheme.primary
                            //             : Colors.grey),
                            //     value: 'distance',
                            //     groupValue: viewModel.autoTriggerType,
                            //     onChanged: (String? value) {
                            //       viewModel.setAutoTriggerType(value!);
                            //     },
                            //   ),
                            // ),
                            // sized(h: 10),
                            // if (viewModel.autoTriggerType == "distance")
                            //   Container(
                            //     alignment: Alignment.centerLeft,
                            //     // width: context.layout.width * 0.6,
                            //     padding: EdgeInsets.symmetric(
                            //       horizontal: kIsWeb ? 25 : 10,
                            //     ),
                            //     child: AppTextField(
                            //       value:
                            //           viewModel.autoTriggerValue?.toString() ??
                            //               "",
                            //       onChanged: (v) {
                            //         viewModel.updateAutoTriggerValue(v);
                            //       },
                            //       suffixIcon: Container(
                            //         alignment: Alignment.centerRight,
                            //         width: 100,
                            //         padding: EdgeInsets.symmetric(
                            //           horizontal: 20,
                            //         ),
                            //         child: Text('meters'),
                            //       ),
                            //       onSaved: (v) {
                            //         if (v != null) {
                            //           viewModel.updateAutoTriggerValue(v);
                            //         }
                            //       },
                            //       label: "Distance value",
                            //       hint: "Enter the minimum activity distance",
                            //     ),
                            //   ),
                            // sized(h: 20),
                            // ListTile(
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(8),
                            //   ),
                            //   onTap: () {
                            //     viewModel.setAutoTriggerType('time');
                            //   },
                            //   leading: Container(
                            //     width: context.layout.width * 0.3,
                            //     // height: 120,
                            //     alignment: Alignment.centerLeft,
                            //     child: Column(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: const [
                            //         AppText(
                            //           "Time",
                            //           fontSize: 20,
                            //         ),
                            //         AppText(
                            //           "Minimum time spent on activity to trigger video creation",
                            //           fontSize: 11,
                            //           maxLines: 2,
                            //           textAlign: TextAlign.left,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            //   trailing: Radio(
                            //     activeColor: appTheme.colorScheme.primary,
                            //     fillColor: WidgetStateProperty.all(
                            //         viewModel.autoTriggerType == 'time'
                            //             ? appTheme.colorScheme.primary
                            //             : Colors.grey),
                            //     value: 'time',
                            //     groupValue: viewModel.autoTriggerType,
                            //     onChanged: (String? value) {
                            //       viewModel.setAutoTriggerType(value!);
                            //     },
                            //   ),
                            // ),
                            // sized(h: 10),
                            // if (viewModel.autoTriggerType == "time")
                            //   Container(
                            //     alignment: Alignment.center,
                            //     width: context.layout.width,
                            //     padding: EdgeInsets.symmetric(
                            //       horizontal: kIsWeb ? 25 : 10.0,
                            //     ),
                            //     child: AppTextField(
                            //       suffixIcon: Container(
                            //         alignment: Alignment.centerRight,
                            //         width: 100,
                            //         padding: EdgeInsets.symmetric(
                            //           horizontal: 20,
                            //         ),
                            //         child: Text('minutes'),
                            //       ),
                            //       value:
                            //           viewModel.autoTriggerValue?.toString() ??
                            //               "",
                            //       onChanged: (v) {
                            //         viewModel.updateAutoTriggerValue(v);
                            //       },
                            //       onSaved: (v) {
                            //         if (v != null) {
                            //           viewModel.updateAutoTriggerValue(v);
                            //         }
                            //       },
                            //       label: "Time value",
                            //       hint: "Enter the minimum activity time",
                            //     ),
                            //   ),
                            // sized(
                            //   h: 20,
                            // ),
                            sized(h: context.layout.height * 0.4),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  final form = formKey.currentState;

                                  if (form != null && form.validate()) {
                                    form.save();
                                    viewModel
                                        .saveUserSettings()
                                        .catchError((err, s) {
                                      logSentry(err, s);

                                      logInfo(
                                        '--------------- ERROR IN SAVING SETTINGS -----',
                                      );

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
 // Row(
                            //   mainAxisSize: MainAxisSize.max,
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     SwitchButton(
                            //       selected: viewModel.preferredUnit == 'metric',
                            //       text: 'Metric',
                            //       gradientColors: [
                            //         Colors.grey[600]!,
                            //         Colors.black,
                            //       ],
                            //       onTap: () {
                            //         //logInfo('Meters selected');
                            //         viewModel.setPreferredUnit('metric');
                            //       },
                            //     ),
                            //     SwitchButton(
                            //       selected:
                            //           viewModel.preferredUnit == 'imperial',
                            //       text: 'Imperial',
                            //       gradientColors: [
                            //         Colors.black,
                            //         Colors.grey[600]!,
                            //       ],
                            //       isFirst: false,
                            //       onTap: () {
                            //         //logInfo('Feet selected');
                            //         viewModel.setPreferredUnit('imperial');
                            //       },
                            //     ),
                            //   ],
                            // ),