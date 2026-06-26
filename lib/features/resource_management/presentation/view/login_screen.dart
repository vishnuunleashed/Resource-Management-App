import 'package:resourcemanagementapp/features/base/presentation/base/base_view.dart';
import 'package:resourcemanagementapp/features/base/presentation/views/base_text_field.dart';
import 'package:resourcemanagementapp/features/base/presentation/views/base_elevated_button.dart';
import 'package:resourcemanagementapp/features/resource_management/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthProvider>(
      provider: authProvider,
      isLoaderRequired: true,
      initState: (context, provider, ref) {},
      backgroundColor: const Color(0xFFF2F7FB), // Premium Canvas color
      builder: (context, provider, ref) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Premium logo area
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0298DB), Color(0xFF4DB8F0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0298DB).withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.dashboard_customize_rounded,
                    size: 46,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Resource Portal",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: const Color(0xFF0F1B2D),
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Enter credentials to manage operations",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),

                // Login form card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFEAF4FB), width: 1.5),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          BaseTextField(
                            controller: _usernameController,
                            displayTitle: "Username",
                            hintText: "Enter username",
                            isRequiredField: true,
                            customValidationMessage: "Username is required",
                            prefixIcon: const Icon(Icons.person_outline_rounded),
                            fillColor: const Color(0xFFFCFEFF),
                          ),
                          const SizedBox(height: 20),
                          BaseTextField(
                            controller: _passwordController,
                            displayTitle: "Password",
                            hintText: "Enter password",
                            isRequiredField: true,
                            customValidationMessage: "Password is required",
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            textInputType: TextInputType.visiblePassword,
                            fillColor: const Color(0xFFFCFEFF),
                            readOnly: false,
                          ),
                          const SizedBox(height: 28),
                          BaseElevatedButton(
                            text: "Sign In",
                            height: 48,
                            borderRadius: 12,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                final success = await provider.login(
                                  _usernameController.text,
                                  _passwordController.text,
                                );
                                if (success && context.mounted) {
                                  context.go('/');
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "Demo User: ADMIN  |  Pass: 1",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
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
