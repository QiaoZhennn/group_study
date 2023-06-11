import 'package:f_group_study/controller/group_controller.dart';
import 'package:f_group_study/features/common/error_text.dart';
import 'package:f_group_study/features/group/user_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';
import '../controller/user_controller.dart';
import '../features/common/loader.dart';
import '../models/group_model.dart';

class GroupScreen extends ConsumerWidget {
  const GroupScreen(this.groupId, {super.key});
  final String groupId;

  bool isCreator(GroupModel model, WidgetRef ref) {
    final user = ref.read(userProvider);
    if (model.createdBy == user!.id) {
      return true;
    }
    return false;
  }

  bool isMember(GroupModel model, WidgetRef ref) {
    final user = ref.read(userProvider);
    if (model.members.contains(user!.id)) {
      return true;
    }
    return false;
  }

  Future<void> onRefresh(WidgetRef ref) async {
    print('refresh group_screen');
    // final user = ref.read(userProvider);
    // ref.invalidate(groupMembersProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GroupModel> groupProvider =
        ref.watch(groupByIdProvider(groupId));
    return Scaffold(
        appBar: AppBar(
          title: const Text('Study Group'),
        ),
        body: groupProvider.when(
            data: (GroupModel group) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  Text('id ${group.id}'),
                  Text('name ${group.name}'),
                  Text('description ${group.description}'),
                  Text('study content ${group.studyContent}'),
                  Text('number of participants ${group.members.length}'),
                  Text('TimeCount ${group.checkResultTimeCount}'),
                  Text('TimeUnit ${group.checkResultTimeUnit}'),
                  Text('isPublic ${group.isPublic}'),
                  Text('userID ${group.createdBy}'),
                  Text('createdAt ${group.createdAt.toLocal()}'),
                  Text('members ${group.members.length}'),
                  if (isCreator(group, ref))
                    ElevatedButton(
                        onPressed: () {
                          print('manage group');
                        },
                        child: const Text('Manage Group')),
                  if (!isMember(group, ref))
                    ElevatedButton(
                        onPressed: () {
                          final groupController =
                              ref.read(groupControllerProvider.notifier);
                          groupController.joinGroups(context, group);
                        },
                        child: const Text('Join Group')),
                  if (isMember(group, ref))
                    ElevatedButton(
                        onPressed: () {
                          final groupController =
                              ref.read(groupControllerProvider.notifier);
                          groupController.leaveGroups(context, group);
                        },
                        child: const Text('Leave Group')),
                  ref.watch(groupMembersProvider(group.id)).when(
                      data: (members) {
                        return Expanded(
                            child: ListView.builder(
                                itemBuilder: (context, index) {
                                  final user = members[index];
                                  return UserSummary(user);
                                },
                                itemCount: members.length));
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader()),
                ]),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader()),
        floatingActionButton: FloatingActionButton(
          onPressed: () => onRefresh(ref),
          child: const Icon(Icons.refresh),
        ));
  }
}
