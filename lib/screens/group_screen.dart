import 'package:f_group_study/controller/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/group_model.dart';

class GroupScreen extends ConsumerStatefulWidget {
  const GroupScreen(this.groupId, {super.key});
  final String groupId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupScreenState();
}

class _GroupScreenState extends ConsumerState<GroupScreen> {
  GroupModel? group;

  void getGroup() async {
    GroupModel? groupModel = await ref
        .read(groupControllerProvider.notifier)
        .getGroupById(context, widget.groupId);
    setState(() {
      group = groupModel;
    });
  }

  @override
  void initState() {
    super.initState();
    getGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Group'),
      ),
      body: group == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                Text('id ${group!.id}'),
                Text('name ${group!.name}'),
                Text('description ${group!.description}'),
                Text('study content ${group!.studyContent}'),
                Text('number of participants ${group!.users.length}'),
                Text('TimeCount ${group!.checkResultTimeCount}'),
                Text('TimeUnit ${group!.checkResultTimeUnit}'),
                Text('isPublic ${group!.isPublic}'),
                Text('userID ${group!.createdBy}'),
                Text('createdAt ${group!.createdAt.toLocal()}'),
              ]),
            ),
    );
  }
}
