import 'package:flutter/material.dart';

import '../../../../../../helpers/enums/voice_over_enum.dart';
import '../../../../../../theme/app_theme.dart';

class BreathingChoices extends StatelessWidget {
  const BreathingChoices(
      {super.key, required this.chosenItem, required this.onUpdateChoiceIndex, required this.onUpdateVoiceOver});

  final int chosenItem;
  final Function(int) onUpdateChoiceIndex;
  final Function(JerryVoiceEnum audio) onUpdateVoiceOver;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choice of breath hold type :', style: TextStyle(fontSize: 16, color: Colors.white)),
        const SizedBox(height: 20.0),
        Wrap(
          direction: Axis.horizontal,
          spacing: 5,
          runSpacing: 5,
          children: [
            ChoiceChip(
              label: Container(
                  alignment: Alignment.center,
                  width: 70,
                  height: 30,
                  child: Text('Breath in',
                      style: TextStyle(color: chosenItem == 0 ? AppTheme.colors.blueNotChosen : Colors.white))),
              shape: const StadiumBorder(side: BorderSide(color: Colors.white)),
              backgroundColor: AppTheme.colors.blueSlider,
              selectedColor: Colors.white,
              checkmarkColor: AppTheme.colors.blueSlider,
              selected: chosenItem == 0,
              onSelected: (bool selected) {
                onUpdateChoiceIndex(selected ? 0 : 0);
                onUpdateVoiceOver(JerryVoiceEnum.breatheIn);
              },
            ),
            ChoiceChip(
              label: Container(
                  alignment: Alignment.center,
                  width: 75,
                  height: 30,
                  child: Text('Breath out',
                      style: TextStyle(color: chosenItem == 1 ? AppTheme.colors.blueNotChosen : Colors.white))),
              shape: const StadiumBorder(side: BorderSide(color: Colors.white)),
              selected: chosenItem == 1,
              backgroundColor: AppTheme.colors.blueSlider,
              selectedColor: Colors.white,
              checkmarkColor: AppTheme.colors.blueSlider,
              onSelected: (bool selected) {
                onUpdateChoiceIndex(selected ? 1 : 1);
                onUpdateVoiceOver(JerryVoiceEnum.breatheOut);
              },
            ),
            ChoiceChip(
              label: Container(
                  alignment: Alignment.center,
                  width: 70,
                  height: 30,
                  child: Text('Both',
                      style: TextStyle(color: chosenItem == 2 ? AppTheme.colors.blueNotChosen : Colors.white))),
              shape: const StadiumBorder(side: BorderSide(color: Colors.white)),
              backgroundColor: AppTheme.colors.blueSlider,
              selectedColor: Colors.white,
              checkmarkColor: AppTheme.colors.blueSlider,
              selected: chosenItem == 2,
              onSelected: (bool selected) {
                onUpdateChoiceIndex(selected ? 2 : 2);
                onUpdateVoiceOver(JerryVoiceEnum.breatheBoth);
              },
            ),
          ],
        ),
      ],
    );
  }
}
