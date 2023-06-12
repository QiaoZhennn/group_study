import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';
import '../controller/repository/user_repository.dart';
import '../controller/user_controller.dart';
import '../models/user_model.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _leetcodeAccountController = TextEditingController();

  void deleteAccount() {
    ref.read(userControllerProvider.notifier).deleteAccount(context);
  }

  void updateUser() {
    final UserModel user = ref.watch(userProvider)!;
    final String name = _nameController.text;
    final String lcAccountName = _leetcodeAccountController.text;
    if (name == user.name && lcAccountName == user.lcAccountName) return;
    ref.read(userRepositoryProvider).updateUser(user.copyWith(
          name: name,
          lcAccountName: lcAccountName,
        ));
  }

  bool modified() {
    final UserModel user = ref.watch(userProvider)!;
    final String name = _nameController.text;
    final String lcAccountName = _leetcodeAccountController.text;
    return name != user.name || lcAccountName != user.lcAccountName;
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = ref.watch(userProvider)!;
    _nameController.text = user.name;
    _leetcodeAccountController.text = user.lcAccountName;
    print(modified());
    return Container(
        // color: Colors.blue,
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: user.email,
                readOnly: true,
                decoration: const InputDecoration(
                  prefix: Text('Email: '),
                  border: InputBorder.none,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    prefixText: 'Username: ', border: UnderlineInputBorder()),
                autocorrect: false,
                controller: _nameController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  prefixText: 'Leetcode account: ',
                  border: UnderlineInputBorder(),
                ),
                autocorrect: false,
                controller: _leetcodeAccountController,
              ),
              ElevatedButton(
                onPressed: updateUser,
                child: const Text('Update'),
              ),
              ElevatedButton(
                onPressed: deleteAccount,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepOrange,
                ),
                child: const Text(
                  'Delete Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
