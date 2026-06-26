import 'package:resourcemanagementapp/features/resource_management/data/models/allocation_model.dart';
import 'package:resourcemanagementapp/features/base/data/services/utils/base_json_parser.dart';

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String client;
  final String status; // Planned, Active, Completed
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final List<AllocationModel> allocations;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.client,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.allocations,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: BaseJsonParser.goodString(json, 'id') ?? '',
      name: BaseJsonParser.goodString(json, 'name') ?? '',
      description: BaseJsonParser.goodString(json, 'description') ?? '',
      client: BaseJsonParser.goodString(json, 'client') ?? '',
      status: BaseJsonParser.goodString(json, 'status') ?? '',
      startDate: BaseJsonParser.goodDateTime(json, 'startDate'),
      endDate: BaseJsonParser.goodDateTime(json, 'endDate'),
      budget: BaseJsonParser.goodDouble(json, 'budget') ?? 0.0,
      allocations: BaseJsonParser.goodList(json, 'allocations')
              .map((e) => AllocationModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'client': client,
      'status': status,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'budget': budget,
      'allocations': allocations.map((e) => e.toJson()).toList(),
    };
  }

  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    String? client,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    double? budget,
    List<AllocationModel>? allocations,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      client: client ?? this.client,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      budget: budget ?? this.budget,
      allocations: allocations ?? this.allocations,
    );
  }
}
