import 'package:resourcemanagementapp/features/base/core/loader_value.dart';
import 'package:resourcemanagementapp/features/base/presentation/provider/base_provider.dart';
import 'package:resourcemanagementapp/features/base/presentation/provider/base_change_notifier.dart';
import 'package:resourcemanagementapp/features/base/data/services/utils/app_exceptions.dart';
import 'package:resourcemanagementapp/features/resource_management/data/models/project_model.dart';
import 'package:resourcemanagementapp/features/resource_management/data/repository/mock_repository.dart';

class ProjectProvider extends BaseProvider {
  final MockRepository _repository = MockRepository();

  List<ProjectModel> _projects = [];
  List<ProjectModel> get projects => _projects;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  String? _statusFilter;
  String? get statusFilter => _statusFilter;

  List<ProjectModel> get filteredProjects {
    return _projects.where((project) {
      // Search check
      final query = _searchQuery.toLowerCase();
      final matchesSearch = project.name.toLowerCase().contains(query) ||
          project.client.toLowerCase().contains(query);

      // Status filter check
      final matchesStatus = _statusFilter == null || project.status == _statusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> fetchProjects({bool silent = false}) async {
    if (!silent) {
      beginLoadingWithStatus();
    }
    try {
      _projects = await _repository.getProjects();
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

  void setStatusFilter(String? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = "";
    _statusFilter = null;
    notifyListeners();
  }
}

final projectProvider = baseChangeNotifier<ProjectProvider>(() => ProjectProvider());
