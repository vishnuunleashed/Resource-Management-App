import 'package:resourcemanagementapp/features/base/presentation/utility/navigator_key.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/auth_provider.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/view/login_screen.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/view/home_main_screen.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/view/resource/resource_detail_screen.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/view/project/project_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: NavigatorKey.navKey,
    initialLocation: '/',
    refreshListenable: auth,
    redirect: (context, state) {
      final isLoggedIn = auth.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeMainScreen(),
      ),
      GoRoute(
        path: '/resource-details/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ResourceDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: '/project-details/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProjectDetailScreen(id: id);
        },
      ),
    ],
  );
});
