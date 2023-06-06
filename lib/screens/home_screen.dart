import 'package:f_group_study/features/group/show_group_list.dart';
import 'package:f_group_study/screens/create_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../controller/auth_controller.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  void createAStudyGroup(BuildContext context) {
    Routemaster.of(context).push('/create_group_screen');
  }

  Future<void> onRefresh(WidgetRef ref) async {
    print('refresh');
    UserModel userModel = await ref
        .read(authControllerProvider.notifier)
        .getUserDataById(ref.read(userProvider.notifier).state!.id);
    ref.read(userProvider.notifier).update((state) => userModel);
    // user = ref.read(userProvider);
    // studyGroupCount = user?.joinedGroups.length ?? 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print('count: $studyGroupCount');
    UserModel? user = ref.watch(userProvider);
    // print('user: $user');
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Container(
        child: Column(children: [
          Text('Home Screen: ${user.name}'),
          ElevatedButton(
            onPressed: () => createAStudyGroup(context),
            child: const Text('Create A Study Group'),
          ),
          Expanded(child: ShowGroupList(user: user)),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onRefresh(ref),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}


// Widget build(BuildContext context, WidgetRef ref) {
//     // print('count: $studyGroupCount');
//     UserModel? user = ref.watch(userProvider);
//     // print('user: $user');
//     return CustomScrollView(
//       slivers: [
//         // if (user != null)
//         //   SliverToBoxAdapter(
//         //     child: Text(
//         //       user!.name,
//         //       overflow: TextOverflow.fade,
//         //     ),
//         //   ),
//         SliverToBoxAdapter(
//           child: ElevatedButton(
//             onPressed: () => createAStudyGroup(context),
//             child: const Text('Create A Study Group'),
//           ),
//         ),
//         SliverToBoxAdapter(child: Text('Joined Groups')),
//         // if (user != null)
//         //   ListView.builder(
//         //     itemBuilder: (context, index) {
//         //       final GroupModel group = user!.joinedGroups[index];
//         //       return Card(
//         //         child: ListTile(
//         //           title: Text(group.name),
//         //         ),
//         //       );
//         //     },
//         //     itemCount: 2,
//         //   )
//       ],
//     );
//   }