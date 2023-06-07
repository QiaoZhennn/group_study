import 'package:f_group_study/controller/group_controller.dart';
import 'package:f_group_study/controller/repository/group_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../models/group_model.dart';
import '../common/error_text.dart';
import '../common/loader.dart';

class SearchGroupDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchGroupDelegate(
    this.ref,
  );

  List<GroupModel> groups = [];

  GroupModel? searchedGroup;

  void searchGroups() async {
    final groupsInSameTimeZone = ref.watch(groupsInSameTimeZoneProvider);
    print(groupsInSameTimeZone.length);
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

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder<GroupModel>(
      future: ref
          .watch(groupRepositoryProvider)
          .getGroupById(query.toLowerCase().trim()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader(); // Display a loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return ErrorText(
              error: snapshot.error
                  .toString()); // Display an error message if an error occurred
        } else if (!snapshot.hasData) {
          return Container(); // Return a default widget or null if no data is available
        } else {
          final GroupModel group = snapshot.data!;
          return ListTile(
            leading: Icon(Icons.group),
            title: Text(group.name),
            subtitle: Text(
              '${group.id} ${group.studyContent}',
              overflow: TextOverflow.ellipsis,
            ),
            dense: true,
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () =>
                Routemaster.of(context).push('/group_screen/${group.id}'),
          );
        }
      },
    );
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
