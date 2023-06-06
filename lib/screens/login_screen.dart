import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/forget_password_widget.dart';
import '../features/auth/google_sign_in_widget.dart';
import '../features/auth/sign_in_widget.dart';
import '../features/auth/sign_up_widget.dart';
import '../features/common/utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isLoading = false;
  String authMode = 'SignInWidget';
  String initialEmail = '';

  void handleLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  void handleAuthMode(String authMode) {
    setState(() {
      this.authMode = authMode;
    });
  }

  void handleInitialEmail(String initialEmail) {
    setState(() {
      this.initialEmail = initialEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      showLoading(context);
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Group Study',
                style: TextStyle(fontSize: 40),
              ),
              Center(
                // alignment: Alignment.center,
                child: Column(children: [
                  if (authMode == 'SignInWidget')
                    SignInWidget(handleAuthMode, handleLoading,
                        handleInitialEmail, initialEmail),
                  if (authMode == 'SignUpWidget')
                    SignUpWidget(handleAuthMode, handleLoading),
                  if (authMode == 'ForgetPasswordWidget')
                    ForgetPasswordWidget(
                        handleAuthMode, handleInitialEmail, initialEmail),
                  if (authMode != 'ForgetPasswordWidget')
                    GoogleSignInWidget(handleLoading),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
