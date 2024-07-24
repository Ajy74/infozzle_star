import 'package:flutter/material.dart';

class BreathingDropDown extends StatelessWidget {
  const BreathingDropDown(
      {super.key,
      required this.onUpdate,
      required this.title,
      required this.numOfItems,
      required this.initialValue,
      required this.identifier,
      required this.showHold});

  final String title;
  final int numOfItems;
  final String initialValue;
  final String identifier;
  final bool showHold;
  final Function(String) onUpdate;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(flex: 4, child: Text(title, style: const TextStyle(fontSize: 16, color: Colors.white))),
      const Spacer(),
      DropdownMenu(
        onSelected: (item) {
          if (item != null) {
            onUpdate(item);
          }
        },
        dropdownMenuEntries: <DropdownMenuEntry<String>>[
          if (!showHold)
            for (int i = 1; i <= numOfItems; i++) DropdownMenuEntry(value: "$i $identifier", label: "$i $identifier"),
          if (showHold) const DropdownMenuEntry(value: "120 sec", label: 'Hold as long as possible')
        ],
        initialSelection: initialValue,
        menuHeight: 300,
        width: showHold ? 235 : 120,
        inputDecorationTheme: const InputDecorationTheme(
          constraints: BoxConstraints.expand(height: 60),
          suffixIconColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 3),
          ),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      )
    ]);
  }
}
