import 'package:resourcemanagementapp/features/base/core/loader_value.dart';
import 'package:resourcemanagementapp/features/base/presentation/provider/base_provider.dart';
import 'package:resourcemanagementapp/features/base/presentation/provider/base_change_notifier.dart';
import 'package:resourcemanagementapp/features/base/data/services/utils/app_exceptions.dart';

class AuthProvider extends BaseProvider {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String? _username;
  String? get username => _username;

  Future<bool> login(String user, String pass) async {
    isLoginProvider = true;
    beginLoadingWithStatus();

    // Premium delay to show off activity indicators
    await Future.delayed(const Duration(milliseconds: 1000));

    if (user.trim().toUpperCase() == 'ADMIN' && pass == '1') {
      _isAuthenticated = true;
      _username = user;
      changeLoadingStatus(loadingStatus: LoadingStatus(loader: Loader.success));
      notifyListeners();
      return true;
    } else {
      changeLoadingStatus(
        loadingStatus: LoadingStatus(
          loader: Loader.error,
          exception: AppException("Invalid Username or Password!"),
        ),
      );
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    _username = null;
    notifyListeners();
  }
}

// Global provider using KeepAlive so authentication persists throughout the session
final authProvider = baseChangeNotifierKeepAlive<AuthProvider>(() => AuthProvider());
