import 'package:f_group_study/controller/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../models/group_model.dart';

class SearchGroupDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchGroupDelegate(
    this.ref,
  );

  List<GroupModel> groups = [];

  GroupModel? searchedGroup;

  void searchGroups() async {
    final groupsInSameTimeZone = ref.read(groupsInSameTimeZoneProvider);
    if (query.isEmpty) {
      groups = [];
      return;
    }
    final List<GroupModel> res = [];
    for (GroupModel group in groupsInSameTimeZone) {
      if (group.id.toLowerCase().contains(query.toLowerCase())) {
        res.add(group);
        if (res.length >= 10) {
          break;
        }
      } else {
        print('not found: $query, ${group.id}');
      }
    }
    groups = res;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  void getGroupById(BuildContext context) async {
    searchedGroup = await ref
        .read(groupControllerProvider.notifier)
        .getGroupById(context, query.toLowerCase().trim());
  }

  @override
  Widget buildResults(BuildContext context) {
    getGroupById(context);
    if (searchedGroup != null) {
      return ListTile(
        leading: Icon(Icons.group),
        title: Text(searchedGroup!.name),
        subtitle: Text(
          '${searchedGroup!.id} ${searchedGroup!.studyContent}',
          overflow: TextOverflow.ellipsis,
        ),
        dense: true,
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () => print("tapped Searched"),
      );
    }
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchGroups();
    return ListView.builder(
      itemBuilder: (context, index) {
        final group = groups[index];
        return GroupListTile(group: group);
      },
      itemCount: groups.length,
    );
  }
}

class GroupListTile extends StatelessWidget {
  const GroupListTile({
    super.key,
    required this.group,
  });

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.group),
      title: Text(group.name),
      subtitle: Text(
        '${group.id} ${group.studyContent}',
        overflow: TextOverflow.ellipsis,
      ),
      dense: true,
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () => Routemaster.of(context).push('/group_screen/${group.id}'),
    );
  }
}
