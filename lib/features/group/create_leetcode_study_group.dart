import 'package:flutter/material.dart';

import 'check_result_time_count_dropdown.dart';
import 'check_result_time_unit_dropdown.dart';

class CreateLeetcodeStudyGroup extends StatefulWidget {
  CreateLeetcodeStudyGroup(this._formKey, {super.key});
  final GlobalKey<FormState> _formKey;

  @override
  State<CreateLeetcodeStudyGroup> createState() =>
      CreateLeetcodeStudyGroupState();
}

class CreateLeetcodeStudyGroupState extends State<CreateLeetcodeStudyGroup> {
  final checkResultCountController = TextEditingController();
  final checkResultPerPenaltyController = TextEditingController();
  String checkResultTimeCount = CheckResultTimeCountDropdown.nameMap[0][0];
  String checkResultTimeUnit = CheckResultTimeUnitDropdown.nameMap[0][0];

  void handleTimeCountDropdown(String value) {
    setState(() {
      checkResultTimeCount = value;
    });
  }

  void handleTimeUnitDropdown(String value) {
    setState(() {
      checkResultTimeUnit = value;
    });
  }

  @override
  void dispose() {
    checkResultCountController.dispose();
    checkResultPerPenaltyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget._formKey,
        child: Column(
          children: [
            Row(
              children: [
                const Text('Check result in every:'),
                const SizedBox(width: 10),
                CheckResultTimeCountDropdown(
                    checkResultTimeCount, handleTimeCountDropdown),
                CheckResultTimeUnitDropdown(
                    checkResultTimeUnit, handleTimeUnitDropdown),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.checklist),
                label: const Text('Total submission needed'),
                hintText: 'Enter positive integer',
                border: UnderlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter penalty';
                } else if (value.contains(' ')) {
                  return 'Penalty cannot contain space';
                } else if (int.tryParse(value) == null) {
                  return 'Please enter a valid integer';
                } else if (int.parse(value) < 0) {
                  return 'Total submission count cannot be negative';
                }
                return null;
              },
              controller: checkResultCountController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              decoration: InputDecoration(
                label: const Text('Penalty per missing submission'),
                icon: Icon(Icons.attach_money),
                hintText: 'Enter positive number',
                border: UnderlineInputBorder(),
              ),
              controller: checkResultPerPenaltyController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter penalty';
                } else if (value.contains(' ')) {
                  return 'Penalty cannot contain space';
                } else if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                } else if (double.parse(value) < 0) {
                  return 'Penalty cannot be negative';
                }
                return null;
              },
            ),
          ],
        ));
  }
}
