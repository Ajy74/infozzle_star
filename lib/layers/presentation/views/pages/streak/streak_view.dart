import 'package:breathpacer/layers/presentation/views/pages/streak/streak_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/streak/streak_view_model.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../helpers/images.dart';
import '../../../../../theme/app_theme.dart';
import '../../shared_widgets/star_magic/custom_button.dart';

class StreakView extends StatelessWidget {
  StreakView({super.key});

  final StreakViewModel viewModel = StreakViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("My Streak"),
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
          drawer: BurgerDrawerView(),
          body: BlocBuilder<StreakViewModel, StreakState>(
            bloc: viewModel,
            builder: (_, state) {
              return SafeArea(
                top: true,
                bottom: true,
                child: Column(
                  children: [
                    buildStreakCircle(state.currentStreak, context),
                    const SizedBox(height: 16),
                    buildStreakIcons(state.streakDays),
                    const SizedBox(height: 16),
                    buildStreakText(state.currentStreak),
                    const SizedBox(height: 16),
                    CustomButton(
                        onTap: () {
                          context.go("/home");
                        },
                        buttonText: "Continue",
                        color: AppTheme.colors.pinkButton),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildStreakCircle(int streakCount, BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          Images.streakRing,
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 3,
        ),
        Column(
          children: [
            Text(
              streakCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 48,
              ),
            ),
            Text(
              viewModel.state.currentStreak == 1 ? 'day in a row' : 'days in a row',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildStreakIcons(List<String> streakDays) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: streakDays.map((day) => buildStreakIcon(day[0])).toList(),
      ),
    );
  }

  Widget buildStreakIcon(String dayInitial) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(Images.streakIcon, width: 35),
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              dayInitial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStreakText(int streakCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 20),
      child: Column(
        children: [
          Text(
            'You’re on a $streakCount day streak\n',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, height: 0.9),
          ),
          Text(
            'Extend your streak to ${(streakCount + 1)} by reaching your meditation goal tomorrow',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
