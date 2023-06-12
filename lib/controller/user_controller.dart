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

  void deleteAccount(BuildContext context) async {
    final UserModel user = _ref.read(userProvider)!;
    try {
      final List<GroupModel> joinedGroups =
          await _ref.watch(joinedGroupsProvider.future);
      final List<GroupModel> updatedGroups = [];
      for (final group in joinedGroups) {
        final groupModel = group.copyWith();
        groupModel.members.remove(user.id);
        updatedGroups.add(groupModel);
      }
      await _ref
          .watch(groupRepositoryProvider)
          .updateGroupsMembers(updatedGroups);
      await _ref.watch(userRepositoryProvider).deleteUserById(user.id);
      await _ref.watch(authControllerProvider.notifier).deleteAccount();
      showSnackBar(context, 'Account ${user.name} is deleted');
    } catch (e) {
      showSnackBar(context, 'Failed to delete account Error: $e');
    }
  }
}
