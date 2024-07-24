import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../helpers/images.dart';
import '../../../../../../theme/app_theme.dart';
import '../../../../domain/models/audio_section_model.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import '../audio_section/audio_section_view.dart';
import 'challenges_state.dart';
import 'challenges_view_model.dart';

//ignore: must_be_immutable
class ChallengesView extends StatelessWidget {
  ChallengesView({super.key});

  ChallengesViewModel viewModel = ChallengesViewModel();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChallengesViewModel()..fetchAllChallenges(),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            drawer: BurgerDrawerView(),
            appBar: AppBar(
              title: const Text("Infinity Challenges"),
              centerTitle: true,
              titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: AppTheme.colors.appBarColor,
              actions: [
                IconButton(
                  icon: const Icon(Icons.home_filled),
                  onPressed: () {
                    context.go("/home");
                  },
                ),
              ],
            ),
            body: SafeArea(
              top: true,
              bottom: true,
              child: Column(
                children: [
                  Image.asset(Images.infinityBanner, width: double.infinity),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildHeader(),
                          buildChallenges(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Infinity Meditation Challenges",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Start Your Journey Today",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "You Really Want to Elevate Your Frequency?\nThen Take Part in these Powerful Challenges.\nIt's ONLY For those that Want to Experience REAL Transformation",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChallenges(BuildContext context) {
    return BlocBuilder<ChallengesViewModel, ChallengesState>(
      bloc: viewModel,
      builder: (context, state) {
        return Column(
          children: [
            buildChallengeCard(context, "7", state.sevenDayChallenge.challenges),
            buildChallengeCard(context, "13", state.thirteenDayChallenge.challenges),
            buildChallengeCard(context, "27", state.twentySevenDayChallenge.challenges),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget buildChallengeCard(BuildContext context, String title, List<AudioSectionModel> challenges) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(gradient: AppTheme.colors.linearChallenge, borderRadius: BorderRadius.circular(20)),
        child: Card(
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.orange, size: 40),
                      const SizedBox(height: 10),
                      Text("$title DAY CHALLENGE",
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
                      Text("Listen to the following meditations in order for the next $title days",
                          textAlign: TextAlign.center)
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ...challenges.asMap().entries.map((entry) {
                  int index = entry.key + 1; // Start numbering from 1
                  AudioSectionModel challenge = entry.value;
                  return Text("$index. ${challenge.title}");
                }),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppTheme.colors.challengePurple)),
                    onPressed: () {
                      viewModel.updateSelectedChallenge(int.parse(title));
                      GoRouter.of(context)
                          .push("/audio_section", extra: AudioSectionArgs(challenges, "Infinity Challenges"));
                    },
                    child: const Text("Take The Challenge", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
