import 'package:f_group_study/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSummary extends ConsumerWidget {
  const UserSummary(this.user, {super.key});
  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          Text('Name: ${user.name}'),
          // Text('Time Zone: ${user.timeZoneOffset}'),
          // Text('Email: ${user.email}'),
          Text('Id: ${user.id.substring(0, 4)}'),
          // Text('lcSubmissions: ${user.lcSubmissions.length}'),
          Text('joinedGroups: ${user.joinedGroups.length}'),
          Text('createdGroups: ${user.createdGroups.length}'),
        ],
      ),
    );
  }
}
