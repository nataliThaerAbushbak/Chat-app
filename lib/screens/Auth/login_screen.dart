import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/Controllers/auth_controller.dart';
import 'register_screen.dart';

// Since GetX handles the state, we can use a clean, memory-efficient StatelessWidget.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get.put() injects the AuthController into memory, making it available for this screen and others.
    final authController = Get.put(AuthController());

    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.school_rounded,
                      size: 84, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome Back',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),

                  // Email Field
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter your email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password Field (Wrapped with Obx to observe visibility toggling)
                  // Obx rebuilds ONLY this specific TextFormField when obscurePassword changes.
                  Obx(() => TextFormField(
                    controller: passwordController,
                    obscureText: authController.obscurePassword.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(authController.obscurePassword.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        // .toggle() is a GetX utility method that flips a boolean value (true <-> false)
                        onPressed: () =>
                            authController.obscurePassword.toggle(),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter your password';
                      return null;
                    },
                  )),
                  const SizedBox(height: 32),

                  // Login Button (Wrapped with Obx to observe loading state)
                  Obx(() => FilledButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () {
                      if (formKey.currentState!.validate()) {
                        authController.loginUser(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      }
                    },
                    child: authController.isLoading.value
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.white),
                    )
                        : const Text('Sign In'),
                  )),
                  const SizedBox(height: 24),

                  // Navigation Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        // Get.to() replaces Navigator.push, providing cleaner syntax without requiring context.
                        onPressed: () => Get.to(() => const RegisterScreen()),
                        child: const Text('Create Account',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}