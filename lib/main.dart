import 'package:resourcemanagementapp/features/base/presentation/theme/theme_config.dart';
import 'package:resourcemanagementapp/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Enforce Portrait mode only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Resource Management System',
      debugShowCheckedModeBanner: false,
      // Strictly Light Mode only
      themeMode: ThemeMode.light,
      theme: AppThemes.light(AppThemeVariant.skyBlue),
      routerConfig: router,
    );
  }
}
