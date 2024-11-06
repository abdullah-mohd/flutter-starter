// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:app/core/const/constants.dart';
import 'package:app/core/extensions/app_consumer_state.dart';
import 'package:app/features/dashboard/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/dashboard/widgets/backdrop_scaffold.dart';
import 'package:app/features/widgets/const_widgets.dart';

class DashboardRoot extends ConsumerStatefulWidget {
  static String get name => 'Dashboard';

  static String get path => '/';
  const DashboardRoot({super.key});

  @override
  AppConsumerState<ConsumerStatefulWidget> createState() {
    return _DashboardRootState();
  }
}

class _DashboardRootState extends AppConsumerState<DashboardRoot> {
  StreamSubscription? _sub;

  @override
  void dispose() {
    if (_sub != null) {
      logInfo('---------------- STREAM CANCELLED');
      _sub!.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    final viewModel = ref.read(dashboardViewModelProvider);
    viewModel.setAppConsumerState(this);
    viewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final appTheme = ref.watch(themeProvider).current.themeData;
    // This is used to connect UI with ViewModel, using ref.watch to observe viewModel changes, so whenever the viewModel's value changes, our UI updates
    // If we use ref.read, it will not observe viewModel changes, so our UI will not update.

    final viewModel = ref.watch(dashboardViewModelProvider);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      statusBarColor: Colors.black,
    ));
    return BackdropScaffold(
      child: viewModel.loading || viewModel.currentUserData == null
          ? const Center(
              child: AppLoader(),
            )
          : viewModel.activePage,
    );
  }
}
