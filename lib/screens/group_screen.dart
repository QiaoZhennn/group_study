import 'package:f_group_study/controller/group_controller.dart';
import 'package:f_group_study/features/common/error_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/common/loader.dart';
import '../models/group_model.dart';

class GroupScreen extends ConsumerStatefulWidget {
  const GroupScreen(this.groupId, {super.key});
  final String groupId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupScreenState();
}

class _GroupScreenState extends ConsumerState<GroupScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<GroupModel> groupProvider =
        ref.watch(groupByIdProvider(widget.groupId));
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
                Text('number of participants ${group.users.length}'),
                Text('TimeCount ${group.checkResultTimeCount}'),
                Text('TimeUnit ${group.checkResultTimeUnit}'),
                Text('isPublic ${group.isPublic}'),
                Text('userID ${group.createdBy}'),
                Text('createdAt ${group.createdAt.toLocal()}'),
              ]),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
