import 'package:f_group_study/features/common/error_text.dart';
import 'package:f_group_study/features/common/loader.dart';
import 'package:f_group_study/models/group_model.dart';
import 'package:f_group_study/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../controller/group_controller.dart';

class ShowGroupList extends ConsumerWidget {
  const ShowGroupList({super.key, required this.user, required this.groups});
  final UserModel user;
  final List<GroupModel> groups;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      // color: Colors.blue,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final groupAsync = ref.watch(groupByIdProvider(groups[index].id));
          return Container(
              // color: Colors.cyan,
              child: groupAsync.when(
            data: (group) {
              return ListTile(
                leading: Icon(Icons.group),
                title: Text(group.name),
                subtitle: Text('num of members: ${group.members.length}'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Routemaster.of(context).push('/group_screen/${group.id}');
                },
              );
            },
            error: (error, stackTrace) => ListTile(
                title: ErrorText(
              error: error.toString(),
            )),
            loading: () => const ListTile(title: const Loader()),
          ));
        },
        itemCount: groups.length,
      ),
    );
  }
}
