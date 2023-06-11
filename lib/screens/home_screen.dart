import 'package:f_group_study/controller/repository/user_repository.dart';
import 'package:f_group_study/controller/user_controller.dart';
import 'package:f_group_study/features/group/show_group_list.dart';
import 'package:f_group_study/screens/create_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../controller/auth_controller.dart';
import '../controller/group_controller.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  void createAStudyGroup(BuildContext context) {
    Routemaster.of(context).push('/create_group_screen');
  }

  Future<void> onRefresh(WidgetRef ref) async {
    print('refresh');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print('count: $studyGroupCount');
    UserModel? user = ref.watch(userProvider);
    // print('user: $user');
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final groups = ref.watch(joinedGroupsProvider);
    // List<GroupModel> groups = [];
    return Scaffold(
      body: Container(
        child: Column(children: [
          Text('Home Screen: ${user.name}'),
          ...user.joinedGroups.map((e) => Text(e)).toList(),
          ElevatedButton(
            onPressed: () => createAStudyGroup(context),
            child: const Text('Create A Study Group'),
          ),
          Expanded(
              child: ShowGroupList(
                  user: user,
                  groups: groups.when(
                      data: (data) => data,
                      error: (error, stackTrace) => [],
                      loading: () => []))),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onRefresh(ref),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
