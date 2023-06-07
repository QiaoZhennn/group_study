import 'package:f_group_study/constants.dart';
import 'package:f_group_study/controller/repository/group_repository.dart';
import 'package:f_group_study/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/common/utils.dart';

final groupControllerProvider = StateNotifierProvider<GroupController, bool>(
    (ref) => GroupController(ref.watch(groupRepositoryProvider), ref));

final groupByIdProvider =
    FutureProvider.family<GroupModel, String>((ref, String id) async {
  final groupRepository = ref.watch(groupRepositoryProvider);
  try {
    final GroupModel groupModel = await groupRepository.getGroupById(id);
    return groupModel;
  } catch (e) {
    rethrow;
  }
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

class GroupController extends StateNotifier<bool> {
  final GroupRepository _groupRepository;
  final Ref _ref;
  GroupController(this._groupRepository, this._ref) : super(false);

  void createGroup(
    BuildContext context,
    GroupModel groupModel,
  ) async {
    state = true;
    try {
      await _groupRepository.getGroupById(groupModel.id);
      showSnackBar(context, 'Group id conflict, please submit again');
      state = false;
    } on DocumentNotFoundExeption catch (e) {
      final res = await _groupRepository.createGroup(groupModel);
      state = false;
      res.fold(
          (l) => showSnackBar(context, l.message),
          (r) => showSnackBar(
              context, 'Successfully created ${groupModel.name} group'));
      _ref.read(groupsInSameTimeZoneProvider.notifier).add(groupModel);
    } catch (e) {
      rethrow;
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
