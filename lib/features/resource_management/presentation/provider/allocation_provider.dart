import 'package:resourcemanagementapp/features/base/core/loader_value.dart';
import 'package:resourcemanagementapp/features/base/presentation/provider/base_provider.dart';
import 'package:resourcemanagementapp/features/base/presentation/provider/base_change_notifier.dart';
import 'package:resourcemanagementapp/features/base/data/services/utils/app_exceptions.dart';
import 'package:resourcemanagementapp/features/resource_management/data/repository/mock_repository.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/resource_provider.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllocationProvider extends BaseProvider {
  final MockRepository _repository = MockRepository();

  Future<bool> allocate({
    required WidgetRef ref,
    required String resourceId,
    required String projectId,
    required String roleInProject,
    required int allocationPercentage,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    beginLoadingWithStatus();

    try {
      final success = await _repository.allocateResource(
        resourceId: resourceId,
        projectId: projectId,
        roleInProject: roleInProject,
        allocationPercentage: allocationPercentage,
        startDate: startDate,
        endDate: endDate,
      );

      if (success) {
        changeLoadingStatus(loadingStatus: LoadingStatus(loader: Loader.success));
        // Refresh resources and projects silently in background
        ref.read(resourceProvider).fetchResources(silent: true);
        ref.read(projectProvider).fetchProjects(silent: true);
        return true;
      } else {
        changeLoadingStatus(
          loadingStatus: LoadingStatus(
            loader: Loader.error,
            exception: AppException("Failed to allocate resource!"),
          ),
        );
        return false;
      }
    } catch (e) {
      changeLoadingStatus(
        loadingStatus: LoadingStatus(
          loader: Loader.error,
          exception: AppException(e.toString()),
        ),
      );
      return false;
    }
  }

  Future<bool> deleteAllocation({
    required WidgetRef ref,
    required String projectId,
    required String allocationId,
  }) async {
    beginLoadingWithStatus();

    try {
      final success = await _repository.removeAllocation(
        projectId: projectId,
        allocationId: allocationId,
      );

      if (success) {
        changeLoadingStatus(loadingStatus: LoadingStatus(loader: Loader.success));
        ref.read(resourceProvider).fetchResources(silent: true);
        ref.read(projectProvider).fetchProjects(silent: true);
        return true;
      } else {
        changeLoadingStatus(
          loadingStatus: LoadingStatus(
            loader: Loader.error,
            exception: AppException("Failed to remove allocation!"),
          ),
        );
        return false;
      }
    } catch (e) {
      changeLoadingStatus(
        loadingStatus: LoadingStatus(
          loader: Loader.error,
          exception: AppException(e.toString()),
        ),
      );
      return false;
    }
  }
}

final allocationProvider = baseChangeNotifierKeepAlive<AllocationProvider>(() => AllocationProvider());
