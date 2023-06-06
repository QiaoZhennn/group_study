import 'package:f_group_study/controller/repository/user_repository.dart';
import 'package:f_group_study/features/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../models/group_model.dart';
import 'auth_controller.dart';

final userControllerProvider = StateNotifierProvider<UserController, bool>(
  (ref) => UserController(ref.watch(userRepositoryProvider), ref),
);

class UserController extends StateNotifier<bool> {
  final UserRepository _userRepository;
  final Ref _ref;

  UserController(this._userRepository, this._ref) : super(false);

  void joinGroups(BuildContext context, GroupModel joinedGroup,
      {GroupModel? createdGroup}) async {
    state = true;
    showLoading(context);
    final String uid = _ref.read(userProvider)!.id;
    final res = await _userRepository.joinGroups(uid, joinedGroup,
        createdGroup: createdGroup);
    state = false;
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => r);
      if (createdGroup == null) {
        print('Successfully joined ${joinedGroup.name} group');
        showSnackBar(context, 'Successfully joined ${joinedGroup.name} group');
      } else {
        print('Successfully created and joined ${joinedGroup.name} group');
      }
      Routemaster.of(context).pop();
    });
  }
}
