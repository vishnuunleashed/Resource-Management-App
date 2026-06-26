import 'dart:developer';
import 'package:resourcemanagementapp/features/base/core/loader_value.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:resourcemanagementapp/features/base/presentation/utility/base_snackbar.dart';
import 'package:resourcemanagementapp/features/base/presentation/utility/navigator_key.dart';
import 'package:flutter/material.dart';

abstract class BaseProvider extends ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus();
  double loadingProgress = 0;
  bool isLoginProvider = false;

  final Map<String, String> _activeTokens = {};
  static const String _kGlobal = '__global__';

  String beginLoading([String slot = _kGlobal]) {
    final token = DateTime.now().microsecondsSinceEpoch.toString();
    _activeTokens[slot] = token;
    return token;
  }

  bool isTokenActive(String token, [String slot = _kGlobal]) {
    return _activeTokens[slot] == token;
  }

  String beginLoadingWithStatus([String slot = _kGlobal]) {
    final token = beginLoading(slot);
    changeLoadingStatus(loadingStatus: LoadingStatus(loader: Loader.loading));
    return token;
  }

  void updateLoadingProgress({required double progress}) {
    loadingProgress = progress;
    notifyListeners();
  }

  void changeLoadingStatus({required LoadingStatus loadingStatus}) async {
    this.loadingStatus = loadingStatus;
    if (loadingStatus.loader == Loader.error) {
      final connectivityResult = await Connectivity().checkConnectivity();
      bool isOffline = connectivityResult.contains(ConnectivityResult.none);
      if (!isOffline || isLoginProvider) {
        BaseSnackBar().show(message: loadingStatus.exception.toString());
      }
    }
    notifyListeners();
  }

  void changeLoadingStatusIfActive({
    required String token,
    required LoadingStatus loadingStatus,
    String slot = _kGlobal,
    bool showSnackbarOnError = true,
  }) async {
    if (!isTokenActive(token, slot)) return;
    this.loadingStatus = loadingStatus;
    if (showSnackbarOnError && loadingStatus.loader == Loader.error) {
      final connectivityResult = await Connectivity().checkConnectivity();
      bool isOffline = connectivityResult.contains(ConnectivityResult.none);
      if (!isOffline || isLoginProvider) {
        BaseSnackBar().show(message: loadingStatus.exception.toString());
      }
    }
    if (NavigatorKey.navKey.currentState!.context.mounted) {
      notifyListeners();
    }
  }

  void changeLoadingStatusMessage({required String updateLoadingMessage}) {
    loadingStatus.message = updateLoadingMessage;
    notifyListeners();
  }

  void saveUUIDToBaseView() {
    changeLoadingStatus(loadingStatus: LoadingStatus(loader: Loader.loading));
    log("UUID saving simulation");
    changeLoadingStatus(loadingStatus: LoadingStatus(loader: Loader.success));
  }

  String getUUID() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  void clearUUID() {
    log("UUID cleared simulation");
  }
}
