import 'package:resourcemanagementapp/features/base/presentation/base/base_view.dart';
import 'package:resourcemanagementapp/features/base/presentation/views/base_text_field.dart';
import 'package:resourcemanagementapp/features/base/presentation/views/base_elevated_button.dart';
import 'package:resourcemanagementapp/features/base/presentation/utility/base_snackbar.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/resource_provider.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/project_provider.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/allocation_provider.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/view/resource/resource_detail_screen.dart' show selectedResourceToAllocateProvider;
import 'package:resourcemanagementapp/features/resource_management/presentation/view/project/project_detail_screen.dart' show selectedProjectToAllocateProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllocationFormTab extends ConsumerStatefulWidget {
  const AllocationFormTab({super.key});

  @override
  ConsumerState<AllocationFormTab> createState() => _AllocationFormTabState();
}

class _AllocationFormTabState extends ConsumerState<AllocationFormTab> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedResourceId;
  String? _selectedProjectId;
  final TextEditingController _roleController = TextEditingController();
  int _allocationPercentage = 50;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 90));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check pre-selected states
      final preSelectedRes = ref.read(selectedResourceToAllocateProvider);
      final preSelectedProj = ref.read(selectedProjectToAllocateProvider);

      if (preSelectedRes != null) {
        setState(() {
          _selectedResourceId = preSelectedRes;
        });
        ref.read(selectedResourceToAllocateProvider.notifier).state = null;
      }

      if (preSelectedProj != null) {
        setState(() {
          _selectedProjectId = preSelectedProj;
        });
        ref.read(selectedProjectToAllocateProvider.notifier).state = null;
      }
    });
  }

  @override
  void dispose() {
    _roleController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: const Color(0xFF0F1B2D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes to pre-selected providers so they autofill reactively
    ref.listen<String?>(selectedResourceToAllocateProvider, (previous, next) {
      if (next != null) {
        setState(() {
          _selectedResourceId = next;
        });
        ref.read(selectedResourceToAllocateProvider.notifier).state = null;
      }
    });

    ref.listen<String?>(selectedProjectToAllocateProvider, (previous, next) {
      if (next != null) {
        setState(() {
          _selectedProjectId = next;
        });
        ref.read(selectedProjectToAllocateProvider.notifier).state = null;
      }
    });

    // Listen to parent listings to build options dropdowns
    final resState = ref.watch(resourceProvider);
    final projState = ref.watch(projectProvider);

    // Calculate remaining availability for each resource
    int getRemainingAvailability(String resourceId) {
      int totalAllocated = 0;
      for (var proj in projState.projects) {
        for (var alloc in proj.allocations) {
          if (alloc.resourceId == resourceId) {
            totalAllocated += alloc.allocationPercentage;
          }
        }
      }
      return 100 - totalAllocated;
    }

    final Map<String, int> resourceAvailabilities = {};
    for (var res in resState.resources) {
      resourceAvailabilities[res.id] = getRemainingAvailability(res.id);
    }

    // Filter resources: must have > 0% remaining availability
    final availableResources = resState.resources.where((r) {
      final remaining = resourceAvailabilities[r.id] ?? 100;
      return remaining > 0;
    }).toList();

    // Make sure the pre-selected resource is included even if it's not in the filtered list
    if (_selectedResourceId != null && !availableResources.any((r) => r.id == _selectedResourceId)) {
      dynamic foundRes;
      for (var r in resState.resources) {
        if (r.id == _selectedResourceId) {
          foundRes = r;
          break;
        }
      }
      if (foundRes != null) {
        availableResources.add(foundRes);
      }
    }

    // Only active and planned projects can be allocated to (exclude Completed)
    final allProjects = projState.projects.where((p) => p.status != 'Completed').toList();

    // Safe dropdown selection values (clamped to null if not loaded yet)
    final String? selectedResValue = availableResources.any((r) => r.id == _selectedResourceId) ? _selectedResourceId : null;
    final String? selectedProjValue = allProjects.any((p) => p.id == _selectedProjectId) ? _selectedProjectId : null;

    return BaseView<AllocationProvider>(
      provider: allocationProvider,
      isLoaderRequired: true,
      initState: (context, provider, ref) {
        // Ensure both resource and project list data is fetched
        ref.read(resourceProvider).fetchResources(silent: true);
        ref.read(projectProvider).fetchProjects(silent: true);
      },
      builder: (context, provider, ref) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  "Assign Resource to Project",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF0F1B2D),
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Set up scheduling and assignment percentage details",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),

                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFEAF4FB), width: 1.5),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Resource Selector
                        Text("Select Resource", style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: selectedResValue,
                          hint: const Text("Select resource name"),
                          decoration: InputDecoration(
                            fillColor: const Color(0xFFFCFEFF),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: availableResources.map((res) {
                            final remaining = resourceAvailabilities[res.id] ?? 100;
                            return DropdownMenuItem<String>(
                              value: res.id,
                              child: Text(
                                "${res.name} (${res.role}) - $remaining% free",
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          validator: (val) {
                            if (val == null) return "Resource is required";
                            final remaining = resourceAvailabilities[val] ?? 100;
                            if (_allocationPercentage > remaining) {
                              return "Exceeds remaining availability ($remaining%)";
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() {
                              _selectedResourceId = val;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Project Selector
                        Text("Select Project", style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: selectedProjValue,
                          hint: const Text("Select project name"),
                          decoration: InputDecoration(
                            fillColor: const Color(0xFFFCFEFF),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: allProjects.map((proj) {
                            return DropdownMenuItem<String>(
                              value: proj.id,
                              child: Text(
                                proj.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          validator: (val) => val == null ? "Project is required" : null,
                          onChanged: (val) {
                            setState(() {
                              _selectedProjectId = val;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Role Input
                        BaseTextField(
                          controller: _roleController,
                          displayTitle: "Role in Project",
                          hintText: "e.g. Lead Engineer, UI Designer",
                          isRequiredField: true,
                          customValidationMessage: "Role is required",
                          fillColor: const Color(0xFFFCFEFF),
                        ),
                        const SizedBox(height: 20),

                        // Allocation Percentage Slider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Allocation Load", style: Theme.of(context).textTheme.titleMedium),
                            Text(
                              "$_allocationPercentage%",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: _allocationPercentage.toDouble(),
                          min: 25,
                          max: 100,
                          divisions: 3, // 25, 50, 75, 100
                          label: "$_allocationPercentage%",
                          activeColor: Theme.of(context).primaryColor,
                          inactiveColor: const Color(0xFFEAF4FB),
                          onChanged: (val) {
                            setState(() {
                              _allocationPercentage = val.toInt();
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Date Pickers Row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Start Date", style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () => _selectDate(context, true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFCFEFF),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(_formatDate(_startDate)),
                                          const Icon(Icons.calendar_month_rounded, size: 18, color: Color(0xFF5A8A9F)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("End Date", style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () => _selectDate(context, false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFCFEFF),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(_formatDate(_endDate)),
                                          const Icon(Icons.calendar_month_rounded, size: 18, color: Color(0xFF5A8A9F)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        BaseElevatedButton(
                          text: "Create Allocation",
                          height: 48,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await provider.allocate(
                                ref: ref,
                                resourceId: _selectedResourceId!,
                                projectId: _selectedProjectId!,
                                roleInProject: _roleController.text.trim(),
                                allocationPercentage: _allocationPercentage,
                                startDate: _startDate,
                                endDate: _endDate,
                              );

                              if (success) {
                                BaseSnackBar().show(message: "Resource allocated successfully!");
                                // Reset form state
                                setState(() {
                                  _selectedResourceId = null;
                                  _selectedProjectId = null;
                                  _roleController.clear();
                                  _allocationPercentage = 50;
                                  _startDate = DateTime.now();
                                  _endDate = DateTime.now().add(const Duration(days: 90));
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
