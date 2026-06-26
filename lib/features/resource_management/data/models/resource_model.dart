import 'package:resourcemanagementapp/features/base/data/services/utils/base_json_parser.dart';

class ResourceModel {
  final String id;
  final String name;
  final String role;
  final String availabilityStatus; // Available, Partially Allocated, Allocated
  final List<String> skills;
  final String contact;
  final double rating;
  final double monthlySalary;

  ResourceModel({
    required this.id,
    required this.name,
    required this.role,
    required this.availabilityStatus,
    required this.skills,
    required this.contact,
    required this.rating,
    required this.monthlySalary,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: BaseJsonParser.goodString(json, 'id') ?? '',
      name: BaseJsonParser.goodString(json, 'name') ?? '',
      role: BaseJsonParser.goodString(json, 'role') ?? '',
      availabilityStatus: BaseJsonParser.goodString(json, 'availabilityStatus') ?? 'Available',
      skills: BaseJsonParser.goodList(json, 'skills').map((e) => e.toString()).toList(),
      contact: BaseJsonParser.goodString(json, 'contact') ?? '',
      rating: BaseJsonParser.goodDouble(json, 'rating') ?? 0.0,
      monthlySalary: BaseJsonParser.goodDouble(json, 'monthlySalary') ?? 40000.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'availabilityStatus': availabilityStatus,
      'skills': skills,
      'contact': contact,
      'rating': rating,
      'monthlySalary': monthlySalary,
    };
  }

  ResourceModel copyWith({
    String? id,
    String? name,
    String? role,
    String? availabilityStatus,
    List<String>? skills,
    String? contact,
    double? rating,
    double? monthlySalary,
  }) {
    return ResourceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      skills: skills ?? this.skills,
      contact: contact ?? this.contact,
      rating: rating ?? this.rating,
      monthlySalary: monthlySalary ?? this.monthlySalary,
    );
  }
}
