import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/auth_controller.dart';

class SignUpWidget extends ConsumerStatefulWidget {
  const SignUpWidget(this.handleAuthMode, this.handleLoading, {super.key});
  final void Function(String authMode) handleAuthMode;
  final void Function(bool isLoading) handleLoading;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends ConsumerState<SignUpWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final reEnterPasswordController = TextEditingController();
  final userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  void signUpWithEmail(BuildContext context, WidgetRef ref) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final userName = userNameController.text.trim();

    ref
        .read(authControllerProvider.notifier)
        .signUpWithEmail(context, email, password, userName);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Email',
            border: OutlineInputBorder(),
          ),
          controller: emailController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            } else if (!EmailValidator.validate(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          controller: passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Re-enter your password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          controller: reEnterPasswordController,
          validator: (value) {
            if (passwordController.text != reEnterPasswordController.text) {
              return 'passwords do not match';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Username',
            border: OutlineInputBorder(),
          ),
          controller: userNameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your user name';
            }
            return null;
          },
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () => signUpWithEmail(context, ref),
            child: Text('Sign Up')),
        Row(
          children: [
            Text('Already have an account? '),
            TextButton(
                onPressed: () => widget.handleAuthMode('SignInWidget'),
                child: const Text('Sign In')),
          ],
        ),
      ]),
    );
  }
}
