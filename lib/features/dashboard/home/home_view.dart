import 'package:app/core/const/constants.dart';
import 'package:app/core/extensions/app_consumer_state.dart';
import 'package:app/core/theme/app_text.dart';
import 'package:app/core/models/user_data.dart';
import 'package:app/features/dashboard/dashboard_view_model.dart';

import 'package:app/features/widgets/app_drawer.dart';
import 'package:app/features/widgets/const_widgets.dart';
import 'package:app/features/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: always_use_package_imports
import 'home_view_model.dart';

class HomeView extends ConsumerStatefulWidget {
  static String get name => 'Home';

  static String get path => 'home';

  const HomeView({super.key});

  @override
  AppConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends AppConsumerState<HomeView>
    with TickerProviderStateMixin {
  UserData? currentUserData;

  final homeScroller = ScrollController();

  @override
  void initState() {
    final viewModel = ref.read(homeViewModelProvider);
    viewModel.setAppConsumerState(this);
    viewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dashVM = ref.watch(dashboardViewModelProvider);
    // final activityVM = ref.watch(activitiesViewModelProvider);

    logInfo(dashVM.authenticationService.firebaseAuth.currentUser);

    logInfo(dashVM.authenticationService.firebaseAuth.currentUser?.phoneNumber);

    // final appTheme = ref.watch(themeProvider).current.themeData;

    return Scaffold(
      appBar: Navbar(
        appBarHeight: AppBar().preferredSize.height,
        color: Colors.grey[100]!,
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          // ...backdropWidgets(context, appTheme),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Theme(
                data: Theme.of(context).copyWith(
                  scrollbarTheme: ScrollbarThemeData(
                    trackColor: WidgetStateProperty.all(Colors.grey[100]),
                    thumbColor: WidgetStateProperty.all(Colors.grey[600]),
                  ),
                ),
                child: Scrollbar(
                  controller: homeScroller,
                  interactive: true,
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        // await _onRefresh();
                      },
                      color: Colors.white,
                      backgroundColor: Colors.blue.withAlpha(100),
                      // enablePullUp: true,
                      child: ListView(
                        controller: homeScroller,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 40),
                            child: AppText(
                              "Welcome to AlignAgain",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          sized(h: 5),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.grey[400],
                                    endIndent: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
