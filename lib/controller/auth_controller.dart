import 'package:f_group_study/controller/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/common/utils.dart';
import '../models/user_model.dart';

// be able to change user state
final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(ref.watch(authRepositoryProvider), ref));

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

// similar to ChangeNotifierProvider
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController(this._authRepository, this._ref) : super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChanges;

  void signUpWithEmail(BuildContext context, String email, String password,
      String username) async {
    state = true;
    final user =
        await _authRepository.signUpWithEmail(email, password, username);
    // l is error, r is success
    state = false;
    user.fold(
        (l) => showSnackBar(context, l.message),
        (r) => _ref
            .read(userProvider.notifier)
            .update((state) => r)); // r is userModel
  }

  void signInWithEmail(
      BuildContext context, String email, String password) async {
    state = true;
    final user = await _authRepository.signInWithEmail(email, password);
    // l is error, r is success
    state = false;
    user.fold(
        (l) => showSnackBar(context, l.message),
        (r) => _ref
            .read(userProvider.notifier)
            .update((state) => r)); // r is userModel
  }

  void signInWithGoogle(BuildContext context) async {
    state =
        true; // this state is the thing we are listening to, initial value is false
    final user = await _authRepository.signInWithGoogle();
    // l is error, r is success
    state = false;
    user.fold(
        (l) => showSnackBar(context, l.message),
        (r) => _ref
            .read(userProvider.notifier)
            .update((state) => r)); // r is userModel
  }

  void sendPasswordResetEmail(BuildContext context, String email) async {
    final user = await _authRepository.sendPasswordResetEmail(email);
    user.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, r));
  }

  void logOut() async {
    _authRepository.logOut();
    // _ref.read(userProvider.notifier).update((state) => null);
  }
}
