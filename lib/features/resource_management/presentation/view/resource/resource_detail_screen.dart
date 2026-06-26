import 'package:resourcemanagementapp/features/base/presentation/base/base_view.dart';
import 'package:resourcemanagementapp/features/base/presentation/views/base_elevated_button.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/resource_provider.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/project_provider.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/allocation_provider.dart';
import 'package:resourcemanagementapp/features/base/presentation/utility/base_snackbar.dart';
import 'package:resourcemanagementapp/features/resource_management/data/models/resource_model.dart';
import 'package:resourcemanagementapp/features/resource_management/data/models/allocation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Selection and Navigation state providers defined here for ease of integration
final selectedResourceToAllocateProvider = StateProvider<String?>((ref) => null);
final activeTabProvider = StateProvider<int>((ref) => 0);

class ResourceDetailScreen extends ConsumerWidget {
  final String id;
  const ResourceDetailScreen({super.key, required this.id});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return const Color(0xFF10B981);
      case 'Partially Allocated':
        return const Color(0xFFF59E0B);
      case 'Allocated':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseView<ResourceProvider>(
      provider: resourceProvider,
      isLoaderRequired: false,
      initState: (context, provider, ref) {
        // Ensure projects are fetched to find allocations
        ref.read(projectProvider).fetchProjects(silent: true);
      },
      builder: (context, provider, ref) {
        final resource = provider.resources.firstWhere(
          (r) => r.id == id,
          orElse: () => ResourceModel(
            id: id,
            name: "Unknown Resource",
            role: "N/A",
            availabilityStatus: "Available",
            skills: [],
            contact: "",
            rating: 0.0,
            monthlySalary: 0.0,
          ),
        );

        final projects = ref.watch(projectProvider).projects;
        final List<AllocationModel> activeAllocations = [];
        for (var project in projects) {
          for (var alloc in project.allocations) {
            if (alloc.resourceId == resource.id) {
              activeAllocations.add(alloc);
            }
          }
        }

        final statusColor = _getStatusColor(resource.availabilityStatus);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Resource Details"),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Profile info
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: const Color(0xFFEAF4FB),
                              child: Text(
                                resource.name.isNotEmpty ? resource.name.substring(0, 1) : "?",
                                style: const TextStyle(
                                  color: Color(0xFF0298DB),
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              resource.name,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: const Color(0xFF0F1B2D),
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              resource.role,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: const Color(0xFF0298DB),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    resource.availabilityStatus,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Contact & Rating Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F7FB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.email_outlined, color: Color(0xFF5A8A9F), size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  resource.contact,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: const Color(0xFF0F1B2D),
                                      ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Divider(color: Colors.white, height: 1),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star_outline_rounded, color: Color(0xFF5A8A9F), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Skill Rating",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: const Color(0xFF0F1B2D),
                                        ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      resource.rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Color(0xFF0F1B2D),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Divider(color: Colors.white, height: 1),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.currency_rupee_rounded, color: Color(0xFF5A8A9F), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Monthly Rate",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: const Color(0xFF0F1B2D),
                                        ),
                                  ),
                                ),
                                Text(
                                  "₹${resource.monthlySalary.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    color: Color(0xFF0F1B2D),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Skills Section
                      Text(
                        "Skills & Technologies",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF0F1B2D),
                            ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: resource.skills.map((skill) {
                          return Chip(
                            label: Text(skill),
                            backgroundColor: const Color(0xFFEAF4FB),
                            side: BorderSide.none,
                            labelStyle: const TextStyle(color: Color(0xFF0298DB), fontWeight: FontWeight.bold),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // Current Allocations
                      Text(
                        "Current Allocations",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF0F1B2D),
                            ),
                      ),
                      const SizedBox(height: 12),
                      if (activeAllocations.isEmpty)
                        Text(
                          "No active project allocations",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic,
                              ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activeAllocations.length,
                          itemBuilder: (context, index) {
                            final alloc = activeAllocations[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFEAF4FB)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.work_outline_rounded, color: Color(0xFF0298DB), size: 24),
                                  const SizedBox(width: 12),
                                   Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          alloc.projectName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F1B2D),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "${alloc.roleInProject}  •  ${alloc.allocationPercentage}%",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text("Delete Allocation"),
                                          content: Text("Are you sure you want to remove ${resource.name} from ${alloc.projectName}?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx, false),
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx, true),
                                              child: const Text("Remove", style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        final success = await ref.read(allocationProvider).deleteAllocation(
                                          ref: ref,
                                          projectId: alloc.projectId,
                                          allocationId: alloc.id,
                                        );
                                        if (success) {
                                          BaseSnackBar().show(message: "Allocation removed successfully!");
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BaseElevatedButton(
                  text: "Allocate to Project",
                  height: 48,
                  onPressed: resource.availabilityStatus == 'Allocated'
                      ? null
                      : () {
                          ref.read(selectedResourceToAllocateProvider.notifier).state = resource.id;
                          ref.read(activeTabProvider.notifier).state = 2; // Allocation tab index
                          context.go('/');
                        },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
