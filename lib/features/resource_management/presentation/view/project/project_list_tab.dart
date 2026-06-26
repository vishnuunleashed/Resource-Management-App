import 'package:resourcemanagementapp/features/base/presentation/base/base_view.dart';
import 'package:resourcemanagementapp/features/base/presentation/views/base_text_field.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/project_provider.dart';
import 'package:resourcemanagementapp/features/resource_management/data/models/project_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProjectListTab extends ConsumerStatefulWidget {
  const ProjectListTab({super.key});

  @override
  ConsumerState<ProjectListTab> createState() => _ProjectListTabState();
}

class _ProjectListTabState extends ConsumerState<ProjectListTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Planned':
        return const Color(0xFF3F51B5); // Indigo
      case 'Active':
        return const Color(0xFF0298DB); // Sky Blue
      case 'Completed':
        return const Color(0xFF10B981); // Emerald
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ProjectProvider>(
      provider: projectProvider,
      isLoaderRequired: true,
      initState: (context, provider, ref) {
        provider.fetchProjects();
      },
      builder: (context, provider, ref) {
        final list = provider.filteredProjects;

        return Column(
          children: [
            // Search Box and Header area
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
              child: BaseTextField(
                controller: _searchController,
                hintText: "Search projects or clients...",
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          provider.updateSearchQuery("");
                        },
                      )
                    : null,
                onChanged: (val) {
                  provider.updateSearchQuery(val);
                },
              ),
            ),

            // Horizontal Filter bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  if (provider.statusFilter != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        avatar: const Icon(Icons.refresh_rounded, size: 16, color: Color(0xFF0298DB)),
                        label: const Text('Reset'),
                        backgroundColor: const Color(0xFFEAF4FB),
                        side: BorderSide.none,
                        onPressed: () {
                          provider.resetFilters();
                        },
                      ),
                    ),

                  // Status filter dropdown
                  _buildDropdownFilter(
                    context: context,
                    label: provider.statusFilter ?? "All Statuses",
                    items: ["Planned", "Active", "Completed"],
                    onSelected: (val) {
                      if (val == null || val.isEmpty) {
                        provider.setStatusFilter(null);
                      } else {
                        provider.setStatusFilter(val);
                      }
                    },
                    isActive: provider.statusFilter != null,
                  ),
                ],
              ),
            ),

            // Main List View
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            "No projects found",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final project = list[index];
                        return _buildProjectCard(context, project);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDropdownFilter({
    required BuildContext context,
    required String label,
    required List<String> items,
    required ValueChanged<String?> onSelected,
    required bool isActive,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            value: "",
            child: Text(
              "Clear Filter",
              style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
            ),
          ),
          ...items.map(
            (item) => PopupMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          ),
        ];
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEAF4FB) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFF0298DB) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF0298DB) : Colors.grey.shade700,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: isActive ? const Color(0xFF0298DB) : Colors.grey.shade600,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectModel project) {
    final statusColor = _getStatusColor(project.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAF4FB), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push('/project-details/${project.id}');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Project Name & Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        project.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF0F1B2D),
                            ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        project.status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 6),

                // Client Label
                Text(
                  "Client: ${project.client}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 12),

                // Timeline & Duration
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF5A8A9F)),
                    const SizedBox(width: 6),
                    Text(
                      "${_formatDate(project.startDate)}  -  ${_formatDate(project.endDate)}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5A8A9F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                const Divider(color: Color(0xFFEAF4FB), height: 1),
                const SizedBox(height: 12),

                // Bottom row: Allocation count and budget details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people_outline_rounded, size: 18, color: Color(0xFF0298DB)),
                        const SizedBox(width: 6),
                        Text(
                          "${project.allocations.length} Resource${project.allocations.length == 1 ? '' : 's'} allocated",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1B2D),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "₹${project.budget.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F1B2D),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
