// ignore_for_file: prefer_null_aware_method_calls

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:app/core/const/constants.dart';
import 'package:app/core/extensions/app_consumer_state.dart';
import 'package:app/core/utils/error_util.dart';
import 'package:flutter/material.dart';
import 'package:app/core/utils/service_response.dart';

class AppViewModel extends ChangeNotifier {
  late final StreamSubscription<List<ConnectivityResult>>
      connectivityChangedSubscription;

  AppViewModel() {
    connectivityChangedSubscription =
        Connectivity().onConnectivityChanged.listen(onConnectivityChanged);
  }

  bool loading = false;

  bool initialized = false;

  bool disposed = false;

  bool connected = false;

  Function(String)? _navigationGo;

  Function(String)? _navigationPush;

  VoidCallback? _navigationPop;

  Function(String, Color? color)? _showSnackBarMessage;

  BuildContext? context;

  void setAppConsumerState(AppConsumerState state) {
    _navigationGo = state.navigationGo;
    _navigationPush = state.navigationPush;
    _navigationPop = state.navigationPop;
    _showSnackBarMessage = state.showSnackBarMessage;
    // _showDialog = state.showMessageDialog;

    context = state.context;
  }

  @mustCallSuper
  Future<void> init() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    connected = connectivityResult.last != ConnectivityResult.none;
  }

  void setLoading(bool loading) {
    this.loading = loading;
    notifyListeners();
  }

  void navigationGo(String path) {
    if (_navigationGo != null) {
      _navigationGo!(path);
    }
  }

  void navigationPush(String path) {
    if (_navigationPush != null) {
      _navigationPush!(path);
    }
  }

  void navigationPop() {
    if (_navigationPop != null) {
      _navigationPop!();
    }
  }

  void showSnackBarMessage(
    String message, {
    Color? backgroundColour = const Color(0xFF993265),
  }) {
    if (_showSnackBarMessage != null) {
      logInfo('Showing SnackBar');
      _showSnackBarMessage!(message, backgroundColour);
    } else {
      logInfo('SnackBar not available');
    }
  }

  void showServiceResponseSnackBar(ServiceResponse serviceResponse) {
    final errorCode = serviceResponse.errorCode ?? 1000;

    final errorMessage = ErrorUtil.getErrorMessage(errorCode);
    showSnackBarMessage(errorMessage);
  }

  void onConnectivityChanged(List<ConnectivityResult> result) {
    connected = result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.ethernet);
  }

  @mustCallSuper
  @override
  void dispose() {
    disposed = true;
    _navigationGo = null;
    _navigationPush = null;
    _navigationPop = null;
    _showSnackBarMessage = null;
    connectivityChangedSubscription.cancel();
    super.dispose();
  }
}
