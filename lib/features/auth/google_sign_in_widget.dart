import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/auth_controller.dart';

class GoogleSignInWidget extends ConsumerStatefulWidget {
  const GoogleSignInWidget(this.handleLoading, {super.key});
  final void Function(bool isLoading) handleLoading;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GoogleSignInWidgetState();
}

class _GoogleSignInWidgetState extends ConsumerState<GoogleSignInWidget> {
  void signInWithGoogle(BuildContext context, WidgetRef ref) async {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => signInWithGoogle(context, ref),
        child: const Text('Sign In with Google'));
  }
}
