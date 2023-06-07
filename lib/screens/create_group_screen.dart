import 'dart:math';

import 'package:f_group_study/controller/auth_controller.dart';
import 'package:f_group_study/features/group/study_content_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../controller/group_controller.dart';
import '../controller/user_controller.dart';
import '../features/common/utils.dart';
import '../features/group/create_leetcode_study_group.dart';
import '../features/group/check_result_time_count_dropdown.dart';
import '../features/group/check_result_time_unit_dropdown.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final groupNameController = TextEditingController();
  final groupDescriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _leetcodeFormKey = GlobalKey<FormState>();
  final _leetcodeKey = GlobalKey<CreateLeetcodeStudyGroupState>();
  bool isPublic = false;
  bool isParticipated = true;
  String selectedStudyContent = StudyContentDropdown.nameMap[0][0];
  Random random = Random();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    groupNameController.dispose();
    groupDescriptionController.dispose();
    super.dispose();
  }

  void handleStudyContentDropdown(String value) {
    setState(() {
      selectedStudyContent = value;
    });
  }

  void submit(BuildContext context) async {
    UserModel user = ref.read(userProvider)!;
    if (selectedStudyContent == StudyContentDropdown.nameMap[0][0]) {
      if (_formKey.currentState!.validate() &&
          _leetcodeFormKey.currentState!.validate()) {
        final groupController = ref.read(groupControllerProvider.notifier);
        final String name = groupNameController.text;
        int randomNumber = random.nextInt(9000) + 1000;
        final String id =
            '${user.id.toLowerCase().substring(0, 4)}${randomNumber}';
        final String description = groupDescriptionController.text;
        final String studyContent = selectedStudyContent;
        final int checkResultCount = int.parse(
            _leetcodeKey.currentState!.checkResultCountController.text);
        final int checkResultTimeCount =
            int.parse(_leetcodeKey.currentState!.checkResultTimeCount);
        final String checkResultTimeUnit =
            _leetcodeKey.currentState!.checkResultTimeUnit;
        final double checkResultPerPenalty = double.parse(
            _leetcodeKey.currentState!.checkResultPerPenaltyController.text);

        final DateTime now = DateTime.now();
        GroupModel groupModel = GroupModel(
            id: id,
            name: name,
            description: description,
            users: isParticipated ? [user.id] : [],
            createdBy: user.id,
            createdAt: now.toUtc(),
            timeZoneOffset: now.timeZoneOffset.inHours,
            isPublic: isPublic,
            studyContent: studyContent,
            checkResultCount: checkResultCount,
            checkResultTimeCount: checkResultTimeCount,
            checkResultTimeUnit: checkResultTimeUnit,
            checkResultPerPenalty: checkResultPerPenalty);
        groupController.createGroup(context, groupModel);
        final userController = ref.read(userControllerProvider.notifier);
        userController.joinGroups(context, groupModel,
            createdGroup: groupModel);
      }
    } else {
      print("WIP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create A Study Group'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Routemaster.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              decoration: InputDecoration(
                label: const Text('Group Name'),
                border: UnderlineInputBorder(),
              ),
              controller: groupNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter group name';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            TextFormField(
              decoration: InputDecoration(
                label: const Text('Group Description (Optional)'),
                border: UnderlineInputBorder(),
              ),
              controller: groupDescriptionController,
              textInputAction: TextInputAction.next,
            ),
            Row(
              children: [
                const Text('Need creator\' approval to join?'),
                Switch(
                    value: isPublic,
                    onChanged: (value) {
                      setState(() {
                        isPublic = value;
                      });
                    }),
              ],
            ),
            Row(
              children: [
                const Text('Will you participate in this study plan?'),
                Switch(
                    value: isParticipated,
                    onChanged: (value) {
                      setState(() {
                        isParticipated = value;
                      });
                    }),
              ],
            ),
            Row(
              children: [
                const Text('Study Content: '),
                StudyContentDropdown(
                    selectedStudyContent, handleStudyContentDropdown),
              ],
            ),
            CreateLeetcodeStudyGroup(_leetcodeFormKey, key: _leetcodeKey),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () => submit(context),
                    child: const Text('Create'))),
          ]),
        ),
      ),
    );
  }
}
