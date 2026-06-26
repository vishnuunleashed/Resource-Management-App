import 'package:resourcemanagementapp/features/base/presentation/base/base_view.dart';
import 'package:resourcemanagementapp/features/base/presentation/views/base_text_field.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/resource_provider.dart';
import 'package:resourcemanagementapp/features/resource_management/data/models/resource_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResourceListTab extends ConsumerStatefulWidget {
  const ResourceListTab({super.key});

  @override
  ConsumerState<ResourceListTab> createState() => _ResourceListTabState();
}

class _ResourceListTabState extends ConsumerState<ResourceListTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return const Color(0xFF10B981); // Emerald Green
      case 'Partially Allocated':
        return const Color(0xFFF59E0B); // Amber
      case 'Allocated':
        return const Color(0xFFEF4444); // Red
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ResourceProvider>(
      provider: resourceProvider,
      isLoaderRequired: true,
      initState: (context, provider, ref) {
        provider.fetchResources();
      },
      builder: (context, provider, ref) {
        final list = provider.filteredResources;

        return Column(
          children: [
            // Search Box and Header area
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
              child: BaseTextField(
                controller: _searchController,
                hintText: "Search resources or skills...",
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
                  // Reset Filters badge if anything is set
                  if (provider.availabilityFilter != null || provider.roleFilter != null)
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

                  // Availability filter dropdown
                  _buildDropdownFilter(
                    context: context,
                    label: provider.availabilityFilter ?? "All Statuses",
                    items: ["Available", "Partially Allocated", "Allocated"],
                    onSelected: (val) {
                      if (val == null || val.isEmpty) {
                        provider.setAvailabilityFilter(null);
                      } else {
                        provider.setAvailabilityFilter(val);
                      }
                    },
                    isActive: provider.availabilityFilter != null,
                  ),
                  const SizedBox(width: 8),

                  // Role filter dropdown
                  _buildDropdownFilter(
                    context: context,
                    label: provider.roleFilter ?? "All Roles",
                    items: [
                      "Software Engineer",
                      "QA Engineer",
                      "UI/UX Designer",
                      "Project Manager",
                      "Frontend Developer",
                      "Backend Developer"
                    ],
                    onSelected: (val) {
                      if (val == null || val.isEmpty) {
                        provider.setRoleFilter(null);
                      } else {
                        provider.setRoleFilter(val);
                      }
                    },
                    isActive: provider.roleFilter != null,
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
                          Icon(Icons.people_outline_rounded, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            "No resources found",
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
                        final resource = list[index];
                        return _buildResourceCard(context, resource);
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

  Widget _buildResourceCard(BuildContext context, ResourceModel resource) {
    final statusColor = _getStatusColor(resource.availabilityStatus);

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
            context.push('/resource-details/${resource.id}');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Name and Rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        resource.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF0F1B2D),
                            ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9DB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            resource.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Color(0xFFB45309),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),

                // Role text
                Text(
                  resource.role,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF0298DB),
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),

                // Skills chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: resource.skills.take(3).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F7FB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color: Color(0xFF5A8A9F),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                const Divider(color: Color(0xFFEAF4FB), height: 1),
                const SizedBox(height: 12),

                // Bottom row: Status and arrow
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFF5A8A9F),
                      size: 16,
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


