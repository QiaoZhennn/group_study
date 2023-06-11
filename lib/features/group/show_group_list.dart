import 'package:f_group_study/models/group_model.dart';
import 'package:f_group_study/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ShowGroupList extends StatelessWidget {
  const ShowGroupList({super.key, required this.user, required this.groups});
  final UserModel user;
  final List<GroupModel> groups;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            // color: Colors.cyan,
            child: ListTile(
              leading: Icon(Icons.group),
              title: Text(groups[index].name),
              subtitle: Text('num of members: ${groups[index].members.length}'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Routemaster.of(context)
                    .push('/group_screen/${groups[index].id}');
              },
            ),
          );
        },
        itemCount: groups.length,
      ),
    );
  }
}
