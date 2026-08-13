import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/Controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get.find() locates the already existing AuthController instance from memory.
    // It prevents creating a duplicate controller instance.
    final authController = Get.find<AuthController>();

    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.person_add_alt_1_rounded,
                      size: 76, color: theme.colorScheme.primary),
                  const SizedBox(height: 36),

                  // Full Name Field
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter your name';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

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

                  // Password Field
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
                        onPressed: () =>
                            authController.obscurePassword.toggle(),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter a password';
                      if (value.length < 6)
                        return 'Must be at least 6 characters';
                      return null;
                    },
                  )),
                  const SizedBox(height: 36),

                  // Register Button
                  Obx(() => FilledButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () {
                      if (formKey.currentState!.validate()) {
                        authController.registerUser(
                          nameController.text.trim(),
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
                        : const Text('Sign Up'),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}