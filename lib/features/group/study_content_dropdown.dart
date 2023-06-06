import 'package:flutter/material.dart';

class StudyContentDropdown extends StatelessWidget {
  StudyContentDropdown(
    this.selectedItem,
    this.handleDropdownChange, {
    super.key,
  });

  final String selectedItem;
  final void Function(String value) handleDropdownChange;

  static const nameMap = [
    ['leetcode', 'Leetcode'],
    ['onlineCourse', 'Online Course'],
    ['englishWords', 'Remember English Words']
  ];
  final List<DropdownMenuItem<String>> items = nameMap.map((element) {
    return DropdownMenuItem<String>(
      value: element[0],
      child: Text(element[1]),
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedItem,
      items: items,
      borderRadius: BorderRadius.circular(10),
      onChanged: (value) {
        handleDropdownChange(value!);
      },
    );
  }
}
