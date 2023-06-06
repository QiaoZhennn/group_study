import 'package:f_group_study/models/user_model.dart';
import 'package:flutter/material.dart';

class ShowGroupList extends StatelessWidget {
  const ShowGroupList({super.key, required this.user});
  final UserModel user;

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
              title: Text(user.joinedGroups[index].name),
              subtitle: Text(user.joinedGroups[index].description),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => print("tapped"),
            ),
          );
        },
        itemCount: user.joinedGroups.length,
      ),
    );
  }
}
