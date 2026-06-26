import 'package:resourcemanagementapp/features/base/presentation/base/base_view.dart';
import 'package:resourcemanagementapp/features/base/presentation/views/base_elevated_button.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/project_provider.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/resource_provider.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/allocation_provider.dart';
import 'package:resourcemanagementapp/features/base/presentation/utility/base_snackbar.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/view/resource/resource_detail_screen.dart' show activeTabProvider;
import 'package:resourcemanagementapp/features/resource_management/data/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Selection state provider defined here for ease of integration
final selectedProjectToAllocateProvider = StateProvider<String?>((ref) => null);

class ProjectDetailScreen extends ConsumerWidget {
  final String id;
  const ProjectDetailScreen({super.key, required this.id});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Planned':
        return const Color(0xFF3F51B5);
      case 'Active':
        return const Color(0xFF0298DB);
      case 'Completed':
        return const Color(0xFF10B981);
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseView<ProjectProvider>(
      provider: projectProvider,
      isLoaderRequired: false,
      initState: (context, provider, ref) {},
      builder: (context, provider, ref) {
        final project = provider.projects.firstWhere(
          (p) => p.id == id,
          orElse: () => ProjectModel(
            id: id,
            name: "Unknown Project",
            description: "N/A",
            client: "N/A",
            status: "Planned",
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            budget: 0.0,
            allocations: [],
          ),
        );

        final resourcesList = ref.watch(resourceProvider).resources;

        double calculateAllocationCost(dynamic alloc) {
          double monthlyRate = 40000;
          for (var res in resourcesList) {
            if (res.id == alloc.resourceId) {
              monthlyRate = res.monthlySalary;
              break;
            }
          }
          final durationDays = alloc.endDate.difference(alloc.startDate).inDays;
          final durationMonths = durationDays > 0 ? (durationDays / 30.0) : 1.0;
          return monthlyRate * (alloc.allocationPercentage / 100.0) * durationMonths;
        }

        double totalSpent = 0;
        for (var alloc in project.allocations) {
          totalSpent += calculateAllocationCost(alloc);
        }
        final spentPercentage = project.budget > 0 ? (totalSpent / project.budget) : 0.0;
        final clampedSpentPercentage = spentPercentage.clamp(0.0, 1.0);

        final statusColor = _getStatusColor(project.status);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Project Details"),
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
                      // Header title, client, status
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF4FB),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.assignment_rounded, color: Color(0xFF0298DB), size: 30),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              project.name,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: const Color(0xFF0F1B2D),
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Client: ${project.client}",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                project.status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Dates & Budget Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F7FB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, color: Color(0xFF5A8A9F), size: 18),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Timeline",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: const Color(0xFF0F1B2D),
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Text(
                                  "${_formatDate(project.startDate)} - ${_formatDate(project.endDate)}",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
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
                                const Icon(Icons.monetization_on_outlined, color: Color(0xFF5A8A9F), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Total Project Budget",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: const Color(0xFF0F1B2D),
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Text(
                                  "₹${project.budget.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    color: Color(0xFF0F1B2D),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
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
                                const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF5A8A9F), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Resource Spent Cost",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: const Color(0xFF0F1B2D),
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Text(
                                  "₹${totalSpent.toStringAsFixed(0)}",
                                  style: TextStyle(
                                    color: totalSpent > project.budget ? Colors.red : const Color(0xFF0F1B2D),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: clampedSpentPercentage,
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  totalSpent > project.budget
                                      ? Colors.red
                                      : (spentPercentage > 0.8 ? Colors.orange : const Color(0xFF0298DB)),
                                ),
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Spent: ${(spentPercentage * 100).toStringAsFixed(1)}%",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "Remaining: ₹${(project.budget - totalSpent).clamp(0.0, double.infinity).toStringAsFixed(0)}",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Description Section
                      Text(
                        "About Project",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF0F1B2D),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                              color: Colors.grey.shade700,
                            ),
                      ),
                      const SizedBox(height: 32),

                      // Resource allocations list
                      Text(
                        "Allocated Resources (${project.allocations.length})",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF0F1B2D),
                            ),
                      ),
                      const SizedBox(height: 12),
                      if (project.allocations.isEmpty)
                        Text(
                          "No resources allocated to this project yet.",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic,
                              ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: project.allocations.length,
                          itemBuilder: (context, index) {
                            final alloc = project.allocations[index];
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
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: const Color(0xFFEAF4FB),
                                    child: Text(
                                      alloc.resourceName.substring(0, 1),
                                      style: const TextStyle(
                                        color: Color(0xFF0298DB),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          alloc.resourceName,
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
                                          content: Text("Are you sure you want to remove ${alloc.resourceName} from this project?"),
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
                                          projectId: project.id,
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
                  text: "Allocate Resource",
                  height: 48,
                  onPressed: project.status == 'Completed'
                      ? null
                      : () {
                          ref.read(selectedProjectToAllocateProvider.notifier).state = project.id;
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
