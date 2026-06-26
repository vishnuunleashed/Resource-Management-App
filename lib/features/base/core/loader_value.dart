import 'package:resourcemanagementapp/features/base/data/services/utils/app_exceptions.dart';

enum Loader { init, success, loading, error }

class LoadingStatus {
  Loader loader = Loader.init;
  String message;
  AppException? exception = AppException("Empty");
  LoadingStatus({this.loader = Loader.init, this.message = "Loading", this.exception});
}
