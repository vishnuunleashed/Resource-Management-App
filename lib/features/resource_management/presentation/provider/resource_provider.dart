import 'package:resourcemanagementapp/features/base/core/loader_value.dart';
import 'package:resourcemanagementapp/features/base/presentation/provider/base_provider.dart';
import 'package:resourcemanagementapp/features/base/presentation/provider/base_change_notifier.dart';
import 'package:resourcemanagementapp/features/base/data/services/utils/app_exceptions.dart';
import 'package:resourcemanagementapp/features/resource_management/data/models/resource_model.dart';
import 'package:resourcemanagementapp/features/resource_management/data/repository/mock_repository.dart';

class ResourceProvider extends BaseProvider {
  final MockRepository _repository = MockRepository();

  List<ResourceModel> _resources = [];
  List<ResourceModel> get resources => _resources;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  String? _roleFilter;
  String? get roleFilter => _roleFilter;

  String? _availabilityFilter;
  String? get availabilityFilter => _availabilityFilter;

  List<ResourceModel> get filteredResources {
    return _resources.where((resource) {
      // Search check
      final query = _searchQuery.toLowerCase();
      final matchesSearch = resource.name.toLowerCase().contains(query) ||
          resource.skills.any((skill) => skill.toLowerCase().contains(query));

      // Role filter check
      final matchesRole = _roleFilter == null || resource.role == _roleFilter;

      // Availability filter check
      final matchesAvailability = _availabilityFilter == null ||
          resource.availabilityStatus == _availabilityFilter;

      return matchesSearch && matchesRole && matchesAvailability;
    }).toList();
  }

  Future<void> fetchResources({bool silent = false}) async {
    if (!silent) {
      beginLoadingWithStatus();
    }
    try {
      _resources = await _repository.getResources();
      changeLoadingStatus(loadingStatus: LoadingStatus(loader: Loader.success));
    } catch (e) {
      changeLoadingStatus(
        loadingStatus: LoadingStatus(
          loader: Loader.error,
          exception: AppException(e.toString()),
        ),
      );
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setRoleFilter(String? role) {
    _roleFilter = role;
    notifyListeners();
  }

  void setAvailabilityFilter(String? status) {
    _availabilityFilter = status;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = "";
    _roleFilter = null;
    _availabilityFilter = null;
    notifyListeners();
  }
}

final resourceProvider = baseChangeNotifier<ResourceProvider>(() => ResourceProvider());
