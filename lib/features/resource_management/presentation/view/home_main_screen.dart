import 'package:resourcemanagementapp/features/base/presentation/utility/base_snackbar.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/auth_provider.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/view/resource/resource_list_tab.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/view/resource/resource_detail_screen.dart' show activeTabProvider;
import 'package:resourcemanagementapp/features/resource_management/presentation/view/project/project_list_tab.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/view/allocation/allocation_form_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeMainScreen extends ConsumerWidget {
  const HomeMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);

    final List<Widget> tabs = [
      const ResourceListTab(),
      const ProjectListTab(),
      const AllocationFormTab(),
    ];

    final List<String> titles = [
      "Resource List",
      "Project List",
      "Resource Allocation",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titles[activeTab]),
            Text(
              "Logged in as ADMIN",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout_rounded, color: Colors.red),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: activeTab,
        children: tabs,
      ),
      floatingActionButton: activeTab == 0
          ? FloatingActionButton.extended(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              onPressed: () {
                BaseSnackBar().show(message: "This feature is yet to come!");
              },
              icon: const Icon(Icons.person_add_rounded),
              label: const Text("Create Resource"),
            )
          : activeTab == 1
              ? FloatingActionButton.extended(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    BaseSnackBar().show(message: 'This feature is yet to come');

                  },
                  icon: const Icon(Icons.add_task_rounded),
                  label: const Text("Create Project"),
                )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeTab,
        onTap: (index) {
          ref.read(activeTabProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded),
            activeIcon: Icon(Icons.people_rounded),
            label: "Resources",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_rounded),
            label: "Projects",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_rounded),
            activeIcon: Icon(Icons.add_circle_rounded),
            label: "Allocate",
          ),
        ],
      ),
    );
  }
}
