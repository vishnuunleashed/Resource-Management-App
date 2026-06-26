import 'dart:convert';
import 'package:resourcemanagementapp/features/resource_management/data/models/resource_model.dart';
import 'package:resourcemanagementapp/features/resource_management/data/models/project_model.dart';
import 'package:resourcemanagementapp/features/resource_management/data/models/allocation_model.dart';

class MockRepository {
  static final MockRepository _instance = MockRepository._();
  MockRepository._() {
    _initData();
  }
  factory MockRepository() => _instance;

  // JSON strings to fulfill mock requirement
  static const String _initialResourcesJson = '''
  [
    {
      "id": "R1",
      "name": "Aarav Sharma",
      "role": "Software Engineer",
      "availabilityStatus": "Available",
      "skills": ["Flutter", "Dart", "Firebase", "Git"],
      "contact": "aarav.sharma@mnc.com",
      "rating": 4.8,
      "monthlySalary": 50000.0
    },
    {
      "id": "R2",
      "name": "Priya Patel",
      "role": "QA Engineer",
      "availabilityStatus": "Available",
      "skills": ["JUnit", "Selenium", "Appium", "CI/CD"],
      "contact": "priya.patel@mnc.com",
      "rating": 4.5,
      "monthlySalary": 35000.0
    },
    {
      "id": "R3",
      "name": "Rohan Verma",
      "role": "UI/UX Designer",
      "availabilityStatus": "Partially Allocated",
      "skills": ["Figma", "Sketch", "Adobe XD", "Wireframing"],
      "contact": "rohan.verma@mnc.com",
      "rating": 4.9,
      "monthlySalary": 40000.0
    },
    {
      "id": "R4",
      "name": "Ananya Iyer",
      "role": "Project Manager",
      "availabilityStatus": "Allocated",
      "skills": ["Agile", "Scrum", "Jira", "Risk Management"],
      "contact": "ananya.iyer@mnc.com",
      "rating": 4.7,
      "monthlySalary": 60000.0
    },
    {
      "id": "R5",
      "name": "Amit Mishra",
      "role": "Frontend Developer",
      "availabilityStatus": "Available",
      "skills": ["React", "Vue", "TypeScript", "HTML/CSS"],
      "contact": "amit.mishra@mnc.com",
      "rating": 4.4,
      "monthlySalary": 45000.0
    },
    {
      "id": "R6",
      "name": "Neha Gupta",
      "role": "Backend Developer",
      "availabilityStatus": "Partially Allocated",
      "skills": ["Node.js", "Python", "PostgreSQL", "Docker"],
      "contact": "neha.gupta@mnc.com",
      "rating": 4.6,
      "monthlySalary": 48000.0
    }
  ]
  ''';

  static const String _initialProjectsJson = '''
  [
    {
      "id": "P1",
      "name": "Google Cloud Migration",
      "description": "Migrating core enterprise infrastructure and database systems to Google Cloud Platform with serverless microservices.",
      "client": "Google Inc",
      "status": "Active",
      "startDate": "2026-01-01T00:00:00.000",
      "endDate": "2026-12-31T00:00:00.000",
      "budget": 150000.0,
      "allocations": [
        {
          "id": "A1",
          "projectId": "P1",
          "projectName": "Google Cloud Migration",
          "resourceId": "R3",
          "resourceName": "Rohan Verma",
          "allocationPercentage": 50,
          "roleInProject": "Lead UI/UX Designer",
          "startDate": "2026-01-01T00:00:00.000",
          "endDate": "2026-06-30T00:00:00.000"
        },
        {
          "id": "A2",
          "projectId": "P1",
          "projectName": "Google Cloud Migration",
          "resourceId": "R4",
          "resourceName": "Ananya Iyer",
          "allocationPercentage": 100,
          "roleInProject": "Project Manager",
          "startDate": "2026-01-01T00:00:00.000",
          "endDate": "2026-12-31T00:00:00.000"
        }
      ]
    },
    {
      "id": "P2",
      "name": "Microsoft Dynamics Integration",
      "description": "Integrating global Microsoft Dynamics CRM/ERP workflows with custom internal messaging and tracking solutions.",
      "client": "Microsoft Corporation",
      "status": "Planned",
      "startDate": "2026-07-01T00:00:00.000",
      "endDate": "2026-11-30T00:00:00.000",
      "budget": 75000.0,
      "allocations": []
    },
    {
      "id": "P3",
      "name": "Amazon Logistics Optimizer",
      "description": "Designing and deploying a machine learning engine to optimize route allocations and freight load metrics.",
      "client": "Amazon Web Services",
      "status": "Completed",
      "startDate": "2025-06-01T00:00:00.000",
      "endDate": "2025-12-31T00:00:00.000",
      "budget": 95000.0,
      "allocations": []
    }
  ]
  ''';

  late List<ResourceModel> _resources;
  late List<ProjectModel> _projects;

  void _initData() {
    final List<dynamic> decodedResources = jsonDecode(_initialResourcesJson);
    _resources = decodedResources.map((e) => ResourceModel.fromJson(e)).toList();

    final List<dynamic> decodedProjects = jsonDecode(_initialProjectsJson);
    _projects = decodedProjects.map((e) => ProjectModel.fromJson(e)).toList();
  }

  // Fetch Resources
  Future<List<ResourceModel>> getResources() async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulating network lag
    return _resources;
  }

  // Fetch Projects
  Future<List<ProjectModel>> getProjects() async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulating network lag
    return _projects;
  }

  // Allocate Resource to a Project
  Future<bool> allocateResource({
    required String resourceId,
    required String projectId,
    required String roleInProject,
    required int allocationPercentage,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000)); // Simulating write delay

    final projectIndex = _projects.indexWhere((p) => p.id == projectId);
    final resourceIndex = _resources.indexWhere((r) => r.id == resourceId);

    if (projectIndex == -1 || resourceIndex == -1) {
      return false;
    }

    final project = _projects[projectIndex];
    final resource = _resources[resourceIndex];

    // Create new allocation
    final allocationId = 'A${DateTime.now().millisecondsSinceEpoch}';
    final newAllocation = AllocationModel(
      id: allocationId,
      projectId: projectId,
      projectName: project.name,
      resourceId: resourceId,
      resourceName: resource.name,
      allocationPercentage: allocationPercentage,
      roleInProject: roleInProject,
      startDate: startDate,
      endDate: endDate,
    );

    // Update Project allocations list
    final List<AllocationModel> updatedAllocations = List.from(project.allocations)..add(newAllocation);
    _projects[projectIndex] = project.copyWith(allocations: updatedAllocations);

    // Calculate total allocations percentage for this resource to update status
    int totalPercentage = 0;
    for (var p in _projects) {
      for (var a in p.allocations) {
        if (a.resourceId == resourceId) {
          totalPercentage += a.allocationPercentage;
        }
      }
    }

    String newStatus = 'Available';
    if (totalPercentage >= 100) {
      newStatus = 'Allocated';
    } else if (totalPercentage > 0) {
      newStatus = 'Partially Allocated';
    }

    _resources[resourceIndex] = resource.copyWith(availabilityStatus: newStatus);

    return true;
  }

  // Remove Allocation
  Future<bool> removeAllocation({
    required String projectId,
    required String allocationId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final projectIndex = _projects.indexWhere((p) => p.id == projectId);
    if (projectIndex == -1) {
      return false;
    }

    final project = _projects[projectIndex];
    final allocIndex = project.allocations.indexWhere((a) => a.id == allocationId);
    if (allocIndex == -1) {
      return false;
    }
    final resourceId = project.allocations[allocIndex].resourceId;

    final List<AllocationModel> updatedAllocations =
        project.allocations.where((a) => a.id != allocationId).toList();
    _projects[projectIndex] = project.copyWith(allocations: updatedAllocations);

    final resourceIndex = _resources.indexWhere((r) => r.id == resourceId);
    if (resourceIndex != -1) {
      final resource = _resources[resourceIndex];
      int totalPercentage = 0;
      for (var p in _projects) {
        for (var a in p.allocations) {
          if (a.resourceId == resourceId) {
            totalPercentage += a.allocationPercentage;
          }
        }
      }

      String newStatus = 'Available';
      if (totalPercentage >= 100) {
        newStatus = 'Allocated';
      } else if (totalPercentage > 0) {
        newStatus = 'Partially Allocated';
      }

      _resources[resourceIndex] = resource.copyWith(availabilityStatus: newStatus);
    }

    return true;
  }
}
