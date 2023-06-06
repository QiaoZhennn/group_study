import 'package:f_group_study/controller/repository/group_repository.dart';
import 'package:f_group_study/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/common/utils.dart';
import 'auth_controller.dart';

final groupControllerProvider = StateNotifierProvider<GroupController, bool>(
    (ref) => GroupController(ref.watch(groupRepositoryProvider), ref));

class GroupController extends StateNotifier<bool> {
  final GroupRepository _groupRepository;
  final Ref _ref;
  GroupController(this._groupRepository, this._ref) : super(false);

  Future<GroupModel> createGroup(
    BuildContext context,
    String id,
    String name,
    String description,
    String studyContent,
    int checkResultCount,
    int checkResultTimeCount,
    String checkResultTimeUnit,
    double checkResultPerPenalty,
    bool isPublic,
    bool isParticipated,
  ) async {
    state = true;
    final user = _ref.read(userProvider)!;
    final String uid = user.id;
    final DateTime now = DateTime.now();
    GroupModel groupModel = GroupModel(
        id: id,
        name: name,
        description: description,
        users: isParticipated ? [uid] : [],
        createdBy: uid,
        createdAt: now.toUtc(),
        timeZoneOffset: now.timeZoneOffset.inHours,
        isPublic: isPublic,
        studyContent: studyContent,
        checkResultCount: checkResultCount,
        checkResultTimeCount: checkResultTimeCount,
        checkResultTimeUnit: checkResultTimeUnit,
        checkResultPerPenalty: checkResultPerPenalty);
    final exist = await _groupRepository.getGroupById(id);
    if (exist.isRight()) {
      state = false;
      showSnackBar(context, 'Group id conflict, please submit again');
      return groupModel;
    }
    final group = await _groupRepository.createGroup(groupModel);
    state = false;
    group.fold((l) => showSnackBar(context, l.message),
        (r) => showSnackBar(context, 'Successfully created ${name} group'));
    return groupModel;
  }
}
