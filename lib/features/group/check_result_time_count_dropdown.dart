import 'package:flutter/material.dart';

class CheckResultTimeCountDropdown extends StatelessWidget {
  CheckResultTimeCountDropdown(
    this.selectedItem,
    this.handleDropdownChange, {
    super.key,
  });

  final String selectedItem;
  final void Function(String value) handleDropdownChange;

  static const nameMap = [
    ['1', '1'],
    ['2', '2'],
    ['3', '3'],
    ['4', '4'],
    ['5', '5'],
    ['6', '6'],
    ['7', '7'],
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
