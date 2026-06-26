import 'package:resourcemanagementapp/features/base/data/services/utils/base_json_parser.dart';

class AllocationModel {
  final String id;
  final String projectId;
  final String projectName;
  final String resourceId;
  final String resourceName;
  final int allocationPercentage;
  final String roleInProject;
  final DateTime startDate;
  final DateTime endDate;

  AllocationModel({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.resourceId,
    required this.resourceName,
    required this.allocationPercentage,
    required this.roleInProject,
    required this.startDate,
    required this.endDate,
  });

  factory AllocationModel.fromJson(Map<String, dynamic> json) {
    return AllocationModel(
      id: BaseJsonParser.goodString(json, 'id') ?? '',
      projectId: BaseJsonParser.goodString(json, 'projectId') ?? '',
      projectName: BaseJsonParser.goodString(json, 'projectName') ?? '',
      resourceId: BaseJsonParser.goodString(json, 'resourceId') ?? '',
      resourceName: BaseJsonParser.goodString(json, 'resourceName') ?? '',
      allocationPercentage: BaseJsonParser.goodInt(json, 'allocationPercentage') ?? 0,
      roleInProject: BaseJsonParser.goodString(json, 'roleInProject') ?? '',
      startDate: BaseJsonParser.goodDateTime(json, 'startDate'),
      endDate: BaseJsonParser.goodDateTime(json, 'endDate'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'projectName': projectName,
      'resourceId': resourceId,
      'resourceName': resourceName,
      'allocationPercentage': allocationPercentage,
      'roleInProject': roleInProject,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
