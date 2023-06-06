import 'dart:ffi';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/auth_controller.dart';

class SignInWidget extends ConsumerStatefulWidget {
  const SignInWidget(this.handleAuthMode, this.handleLoading,
      this.handleInitialEmail, this.initialEmail,
      {super.key});
  final String initialEmail;
  final void Function(String authMode) handleAuthMode;
  final void Function(bool isLoading) handleLoading;
  final void Function(String initialEmail) handleInitialEmail;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends ConsumerState<SignInWidget> {
  late final TextEditingController emailController;
  final passwordController = TextEditingController();
  bool isSignIn = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signInWithGoogle(BuildContext context, WidgetRef ref) async {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  void signInWithEmail(BuildContext context, WidgetRef ref) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    ref
        .read(authControllerProvider.notifier)
        .signInWithEmail(context, email, password);
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
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () => signInWithEmail(context, ref),
            child: Text('Log In')),
        ElevatedButton(
            onPressed: () => ref.read(authControllerProvider.notifier).logOut(),
            child: Text('Log Out')),
        Row(
          children: [
            Text('Forget password? '),
            TextButton(
                onPressed: () {
                  widget.handleInitialEmail(emailController.text.trim());
                  widget.handleAuthMode('ForgetPasswordWidget');
                },
                child: const Text('Reset Password')),
          ],
        ),
        Row(
          children: [
            Text('Don\'t have an account? '),
            TextButton(
                onPressed: () => widget.handleAuthMode('SignUpWidget'),
                child: const Text('Sign Up')),
          ],
        ),
      ]),
    );
  }
}
