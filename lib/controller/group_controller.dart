import 'package:f_group_study/constants.dart';
import 'package:f_group_study/controller/repository/group_repository.dart';
import 'package:f_group_study/controller/repository/user_repository.dart';
import 'package:f_group_study/controller/user_controller.dart';
import 'package:f_group_study/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../features/common/utils.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

final groupControllerProvider = StateNotifierProvider<GroupController, bool>(
    (ref) => GroupController(ref.watch(groupRepositoryProvider), ref));

final groupByIdProvider =
    StreamProvider.family<GroupModel, String>((ref, String id) {
  return ref.watch(groupRepositoryProvider).getGroupById(id);
});

final groupsInSameTimeZoneProvider =
    StateNotifierProvider<GroupInSameTimeZone, List<GroupModel>>(
        (ref) => GroupInSameTimeZone());

class GroupInSameTimeZone extends StateNotifier<List<GroupModel>> {
  GroupInSameTimeZone() : super([]);
  set groupsInSameTimeZone(List<GroupModel> groups) {
    state = groups;
  }

  void add(GroupModel group) {
    state.add(group);
  }
}

final groupMembersProvider =
    FutureProvider.family<List<UserModel>, String>((ref, String groupId) async {
  final group = await ref.watch(groupByIdProvider(groupId).future);
  return ref.watch(groupRepositoryProvider).getGroupMembers(group);
});

final joinedGroupsProvider = FutureProvider<List<GroupModel>>((ref) {
  final user = ref.watch(userProvider);
  if (user == null) {
    return Future.value([]);
  }
  return ref.watch(groupRepositoryProvider).getJoinedGroupsByUser(user).first;
});

class GroupController extends StateNotifier<bool> {
  final GroupRepository _groupRepository;
  final Ref _ref;
  GroupController(this._groupRepository, this._ref) : super(false);

  void createGroup(
    BuildContext context,
    GroupModel groupModel,
    bool isMember,
  ) async {
    state = true;
    try {
      final a = _groupRepository.getGroupById(groupModel.id);
      a.listen((event) {
        state = false;
        showSnackBar(context, 'Group id conflict, please submit again');
      }, onError: (error) async {
        if (error is DocumentNotFoundExeption) {
          await _groupRepository.createGroup(groupModel);
          final user = _ref.read(userProvider)!;
          final newUser = user.copyWith();
          if (!user.createdGroups.contains(groupModel.id)) {
            newUser.createdGroups.add(groupModel.id);
          }
          if (isMember && !user.joinedGroups.contains(groupModel.id)) {
            newUser.joinedGroups.add(groupModel.id);
          }
          await _ref.watch(userRepositoryProvider).updateUser(newUser);
          state = false;
          _ref.read(userProvider.notifier).update((state) => newUser);
          showSnackBar(
              context, 'Successfully created ${groupModel.name} group');
          _ref.read(groupsInSameTimeZoneProvider.notifier).add(groupModel);
          Routemaster.of(context).pop();
        }
      });
    } catch (e) {
      print('group_controller createGroup exception: $e');
      rethrow;
    }
  }

  void joinGroups(BuildContext context, GroupModel joinedGroup) async {
    print('user_controller joinGroups');
    state = true;
    final UserModel user = _ref.read(userProvider)!;
    if (joinedGroup.members.contains(user.id)) {
      state = false;
      showSnackBar(context, 'You have already joined this group');
      return;
    }
    joinedGroup.members.add(user.id);
    final newUser =
        user.copyWith(joinedGroups: [...user.joinedGroups] + [joinedGroup.id]);
    // user.joinedGroups.add(joinedGroup.id);
    // _ref.invalidate(userProvider);
    _ref.watch(userProvider.notifier).update((oldUser) => newUser);
    try {
      final updateUserFuture =
          _ref.watch(userRepositoryProvider).updateUser(newUser);
      final updateGroupFuture =
          _ref.watch(groupRepositoryProvider).updateGroup(joinedGroup);
      await Future.wait([updateUserFuture, updateGroupFuture]);
      state = false;
      // ignore: use_build_context_synchronously
      // _ref.watch(userProvider.notifier).update((state) => user);

      // _ref.invalidate(groupMembersProvider(joinedGroup.id));
      print('Successfully joined ${joinedGroup.name} group');
      showSnackBar(context, 'Successfully joined ${joinedGroup.name} group');
      Routemaster.of(context).pop();
    } catch (e) {
      state = false;
      // ignore: use_build_context_synchronously
      print('Failed to join group: $e');
      showSnackBar(context, 'Failed to join group: $e');
    }
  }

  void leaveGroups(BuildContext context, GroupModel joinedGroup) async {
    print('user_controller leaveGroups');
    state = true;
    final UserModel user = _ref.read(userProvider)!;
    joinedGroup.members.remove(user.id);
    // user.joinedGroups.remove(joinedGroup.id);
    final newUser = user.copyWith(
        joinedGroups: user.joinedGroups
            .where((element) => element != joinedGroup.id)
            .toList());
    // _ref.invalidate(userProvider);
    _ref.watch(userProvider.notifier).update((oldUser) => newUser);
    try {
      final updateUserFuture =
          _ref.watch(userRepositoryProvider).updateUser(newUser);
      final updateGroupFuture =
          _ref.watch(groupRepositoryProvider).updateGroup(joinedGroup);
      await Future.wait([updateUserFuture, updateGroupFuture]);
      state = false;
      print('Left ${joinedGroup.name} group');
      showSnackBar(context, 'Left ${joinedGroup.name} group');
      Routemaster.of(context).pop();
    } catch (e) {
      state = false;
      // ignore: use_build_context_synchronously
      print('Failed to leave group: $e');
      showSnackBar(context, 'Failed to leave group: $e');
    }
  }

  void fetchGroupsInTimeZone(int timeZoneOffset) async {
    final groupsInSameTimeZone = await _ref
        .read(groupRepositoryProvider)
        .getAllGroupsInSameTimeZone(timeZoneOffset);
    _ref.read(groupsInSameTimeZoneProvider.notifier).groupsInSameTimeZone =
        groupsInSameTimeZone;
  }
}
