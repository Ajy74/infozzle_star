import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/layers/domain/models/leaderboard_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/leaderboards/leaderboard_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/leaderboards/leaderboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../theme/app_theme.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';

//ignore: must_be_immutable
class LeaderboardView extends StatelessWidget {
  LeaderboardView({super.key});

  LeaderboardViewModel viewModel = LeaderboardViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          drawer: BurgerDrawerView(),
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Top 20 Meditators"),
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
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<LeaderboardViewModel, LeaderboardState>(
                  bloc: viewModel,
                  builder: (_, state) {
                    if (state.showErrorMessage) {
                      Future.microtask(() => ArtSweetAlert.show(
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                              dialogDecoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              type: ArtSweetAlertType.danger,
                              title: "Failed to fetch Leaderboards",
                              text: "An error occurred while fetching leaderboards, please try again.",
                            ),
                          ));
                      state.showErrorMessage = false;
                    }
                    return SafeArea(
                      top: true,
                      bottom: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (state.isLoading)
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                            ),
                          buildPodium(state.leaderboard, context),
                          const SizedBox(height: 20),
                          buildLeaderboard(state.leaderboard),
                          buildFootnote(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPodium(List<LeaderboardModel> leaderboard, BuildContext context) {
    if (leaderboard.length < 3) {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: const Text(
          "Not enough data to display podium",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPodiumPosition(position: 2, userName: leaderboard[1].userName, height: 100, context: context),
          const SizedBox(width: 5),
          _buildPodiumPosition(position: 1, userName: leaderboard[0].userName, height: 150, context: context),
          const SizedBox(width: 5),
          _buildPodiumPosition(position: 3, userName: leaderboard[2].userName, height: 80, context: context),
        ],
      ),
    );
  }

  Widget _buildPodiumPosition({
    required int position,
    required String userName,
    required double height,
    required BuildContext context,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          userName,
          style: const TextStyle(color: Colors.white),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3 - 20,
          height: height,
          decoration: BoxDecoration(
            gradient: AppTheme.colors.linearLeaderboard,
          ),
          child: Center(
            child: Text(
              '$position',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLeaderboard(List<LeaderboardModel> leaderboard) {
    return Expanded(
      child: Column(
        children: [
          Container(
            decoration:
                BoxDecoration(color: AppTheme.colors.leaderboardPurple, borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Row(children: [
              Flexible(
                child: Text(
                  "Weekly Leaderboard",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Spacer(),
              Flexible(
                child: Text(
                  "Meditations Completed",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                LeaderboardModel user = leaderboard[index];
                return ListTile(
                  title: Text(
                    "${index + 1}. ${user.userName}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Text(user.score.toString(), style: const TextStyle(color: Colors.white, fontSize: 14)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFootnote() {
    return const Text(
      "*This screen is updated with latest results every 10 minutes.",
      style: TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
    );
  }
}
