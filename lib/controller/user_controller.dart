import 'package:f_group_study/controller/group_controller.dart';
import 'package:f_group_study/controller/repository/group_repository.dart';
import 'package:f_group_study/controller/repository/user_repository.dart';
import 'package:f_group_study/features/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../models/group_model.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

final userControllerProvider = StateNotifierProvider<UserController, bool>(
  (ref) => UserController(ref.watch(userRepositoryProvider), ref),
);

final userByIdProvider = StreamProvider.family<UserModel, String>((ref, id) {
  return ref.watch(userRepositoryProvider).getUserById(id);
});

class UserController extends StateNotifier<bool> {
  final UserRepository _userRepository;
  final Ref _ref;

  UserController(this._userRepository, this._ref) : super(false);
}
