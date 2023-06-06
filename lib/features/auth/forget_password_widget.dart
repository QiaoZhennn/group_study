import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/auth_controller.dart';

class ForgetPasswordWidget extends ConsumerStatefulWidget {
  const ForgetPasswordWidget(
      this.handleAuthMode, this.handleInitialEmail, this.initialEmail,
      {super.key});
  final String initialEmail;
  final void Function(String authMode) handleAuthMode;
  final void Function(String initialEmail) handleInitialEmail;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgetPasswordWidgetState();
}

class _ForgetPasswordWidgetState extends ConsumerState<ForgetPasswordWidget> {
  late final TextEditingController emailController;
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
    super.dispose();
  }

  void sendPasswordResetEmail(BuildContext context, WidgetRef ref) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final email = emailController.text.trim();
    ref
        .read(authControllerProvider.notifier)
        .sendPasswordResetEmail(context, email);
    widget.handleInitialEmail(email);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Reset password email',
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
        ElevatedButton(
            onPressed: () => sendPasswordResetEmail(context, ref),
            child: Row(
              children: [
                Icon(Icons.email_outlined),
                Text('Reset Password'),
              ],
            )),
        Row(
          children: [
            Text('Remember password?'),
            TextButton(
                onPressed: () => widget.handleAuthMode('SignInWidget'),
                child: const Text('Sign In')),
          ],
        ),
      ]),
    );
  }
}
