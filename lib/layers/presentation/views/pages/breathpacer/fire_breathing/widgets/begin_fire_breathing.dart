import 'package:breathpacer/helpers/enums/breathing_enum.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/breathpacer/components/button_breathing.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/breathpacer/components/top_area_breathing.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../shared_widgets/breathpacer/components/warning_breathing.dart';

//ignore: must_be_immutable
class BeginFireBreathing extends StatelessWidget {
  BeginFireBreathing({super.key, required this.pageController});

  final PageController pageController;
  YoutubePlayerController controller = YoutubePlayerController(
    initialVideoId: 'Utb8Et5cnuM',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TopArea(
          onBackButtonPressed: () {},
          title: "Fire breathpacer",
          hasIcon: false,
          iconTitle: "",
          iconEnum: BreathingIconEnum.nothing,
          hasBackButton: true,
        ),
        const SizedBox(height: 20),
        const WarningText(),
        const SizedBox(height: 60),
        YoutubePlayer(
          controller: controller,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
        ),
        const SizedBox(height: 60),
        BreathingButton(
          pageController: pageController,
          buttonText: 'Ok, start now !',
          onTap: () {},
        ),
      ],
    ));
  }
}
